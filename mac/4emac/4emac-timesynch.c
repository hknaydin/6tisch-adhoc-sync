/*
 * Copyright (c) 2015, Mavialp Research Limited.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the Institute nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE INSTITUTE AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE INSTITUTE OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 *
 */

/**
 * \file
 *         A Time Synchronisation mechanism that uses ACK frames and a Keep alive timer.
 * \author
 *         Sedat Gormus <sedatgormus@gmail.com>
 */

#include "contiki.h"
#if PLATFORM_HAS_LEDS
#include "dev/leds.h"
#endif
#if TSCH_TIME_SYNCH
#include "net/link-stats.h"
#include "net/mac/4emac/4emac-private.h"
#include "net/mac/4emac/ieee802154e.h"
#include "net/packetbuf.h"
#if FOURE_KA_ENABLE
#include "net/mac/4emac/6top-pce/nbr-cell-table.h"
#endif /* FOURE_KA_ENABLE */

#if SIX_TISCH_SECURE_JOIN
void secure_join_init(int joined);
#endif /* SIX_TISCH_SECURE_JOIN */

#include <stdlib.h>

#include "sys/log.h"
#define LOG_MODULE "4EMAC-SYN"
#ifndef LOG_CONF_LEVEL_4EMAC
#define LOG_LEVEL LOG_LEVEL_INFO
#else
#define LOG_LEVEL LOG_CONF_LEVEL_4EMAC
#endif



uint8_t MIN_EB_INTERVAL_MUL;
uint8_t MAX_EB_INTERVAL_MUL;

/*------------------------------------------------------------------------------*/
PROCESS(foure_timesynch_process, "TSCH Synch");
PROCESS(foure_timesynch_hopping_process, "Ch. Hop");
#if FOURE_ADHOC_SYNC_ENABLED
PROCESS(foure_adhoc_sync_process, "AdHoc Sync");
#endif /* FOURE_ADHOC_SYNC_ENABLED */
/*------------------------------------------------------------------------------*/
struct foure_mac_control foure_control;
struct asn_t current_asn;

static uint8_t authority_level;

static linkaddr_t *timesynch_destination;
/*------------------------------------------------------------------------------*/
struct stimer eb_freshness, eack_freshness;
/*------------------------------------------------------------------------------*/
uint16_t slot_frame_size;
/*------------------------------------------------------------------------------*/
extern uint8_t foure_seqno;
/*------------------------------------------------------------------------------*/
/* TSCH timeslot timing (in micro-second) */
uint16_t tsch_timing_us[ts_elements_count];
uint16_t slot_duration_us;
/* TSCH timeslot timing (in rtimer-ticks) */
rtimer_clock_t tsch_timing_rt[ts_elements_count];
rtimer_clock_t slot_duration_rt;
/*------------------------------------------------------------------------------*/
/* TSCH channel hopping sequence */
uint8_t foure_channel_hopping_pattern[NUMBER_OF_MAX_CHANNELS];
uint8_t foure_channel_hopping_pattern_len;
/*------------------------------------------------------------------------------*/
/* TSCH Shared cells */
scell_t hard_slots[FOURE_MAX_HARD_SLOT];
uint8_t hard_slot_len;

/*------------------------------------------------------------------------------*/
/* Default TSCH timeslot timing (in micro-second) */
static const uint16_t tsch_default_timing_us[ts_elements_count] = {
  FOURE_DEFAULT_TS_CCA_OFFSET,
  FOURE_DEFAULT_TS_CCA,
  FOURE_DEFAULT_TS_TX_OFFSET,
  FOURE_DEFAULT_TS_RX_OFFSET,
  FOURE_DEFAULT_TS_RX_ACK_DELAY,
  FOURE_DEFAULT_TS_TX_ACK_DELAY,
  FOURE_DEFAULT_TS_RX_WAIT,
  FOURE_DEFAULT_TS_ACK_WAIT,
  FOURE_DEFAULT_TS_RX_TX,
  FOURE_DEFAULT_TS_MAX_ACK,
  FOURE_DEFAULT_TS_MAX_TX,
  FOURE_DEFAULT_TS_TIMESLOT_LENGTH
};
/* Default TSCH minimal timeslot timing (in micro-second) */
const uint16_t tsch_minimal_default_timing_us[ts_elements_count] = { 
  TSCH_MINIMAL_DEFAULT_TS_CCA_OFFSET,
  TSCH_MINIMAL_DEFAULT_TS_CCA,
  TSCH_MINIMAL_DEFAULT_TS_TX_OFFSET,
  TSCH_MINIMAL_DEFAULT_TS_RX_OFFSET,
  TSCH_MINIMAL_DEFAULT_TS_RX_ACK_DELAY,
  TSCH_MINIMAL_DEFAULT_TS_TX_ACK_DELAY,
  TSCH_MINIMAL_DEFAULT_TS_RX_WAIT,
  TSCH_MINIMAL_DEFAULT_TS_ACK_WAIT,
  TSCH_MINIMAL_DEFAULT_TS_RX_TX,
  TSCH_MINIMAL_DEFAULT_TS_MAX_ACK,
  TSCH_MINIMAL_DEFAULT_TS_MAX_TX,
  TSCH_MINIMAL_DEFAULT_TS_TIMESLOT_LENGTH
};
/* Default TSCH minimal channel hopping sequence */
const uint8_t tsch_minimal_default_channel_hopping_pattern[] = TSCH_MINIMAL_CHANNEL_HOPPING_PATTERN;
const uint8_t tsch_minimal_default_channel_hopping_pattern_len = TSCH_MINIMAL_CHANNEL_HOPPING_PATTERN_LEN;
/*------------------------------------------------------------------------------*/
#if PLATFORM_HAS_OTA_SYS
void ota_arch_init();
#endif /* PLATFORM_HAS_OTA_SYS */

/*------------------------------------------------------------------------------*/
/** \brief Stores data about an incoming packet */
struct input_packet {
  uint8_t payload[TSCH_PACKET_MAX_LEN]; /* Packet payload */
  struct asn_t rx_asn;
  int len; /* Packet len */
  int16_t rssi; /* RSSI for this packet */
  uint8_t channel; /* Channel we received the packet on */
};

#define FOURE_ASSOCIATION_POLL_FREQUENCY 100
#define FOURE_CHANNEL_SCAN_DURATION CLOCK_SECOND

/*------------------------------------------------------------------------------*/
rpl_rank_t
get_current_instance_rank()
{
/* [Mavi Alp Research Proprietary Code Redacted] */
}

/*------------------------------------------------------------------------------
 * Return the authority level of the node
 */
uint8_t
tsch_timesynch_authority_level(void)
{
  /* [Mavi Alp Research Proprietary Code Redacted] */
  return authority_level;
}

/*------------------------------------------------------------------------------
 * Set the authority level of the node. The authorithy level is obtained from
 * the rank of the node.
 */
void
tsch_timesynch_set_authority_level(uint8_t level)
{
  /* [Mavi Alp Research Proprietary Code Redacted] */
  authority_level = level;
}

/*---------------------------------------------------------------------------------------
 * Routing layer callback for the default route change, default router is the time master
 */
void
foure_timesynch_parent_switch_callback(rpl_parent_t *old, rpl_parent_t *new)
{
  /* [Mavi Alp Research Proprietary Code Redacted] */
}


/*---------------------------------------------------------------------------*/
/* Set TSCH EB period based on current RPL DIO period.
 * To use, set #define RPL_CALLBACK_NEW_DIO_INTERVAL tsch_rpl_callback_new_dio_interval */
void
rpl_foure_start_callback(uint8_t is_coordinator)
{
  /* [Mavi Alp Research Proprietary Code Redacted] */
  foure_timesynch_init(is_coordinator);
}

/*------------------------------------------------------------------------------
 * Join the most suitable TSCH time master
 */
uint8_t
tsch_join(linkaddr_t *linkaddr, struct ieee802154_eb *eb)
{
 /* [Mavi Alp Research Proprietary Code Redacted] */
}

/*------------------------------------------------------------------------------
 * Receive and process the enhanced beacon. The beacon is used for time synchronisation
 * in non-minimal setting. In the minimal draft implementation, beacon receive time is
 * used to estimate the start of the slot.
 */

void
tsch_eb_input()
{
 /* [Mavi Alp Research Proprietary Code Redacted] */
}

/*------------------------------------------------------------------------------
 * Send enhanced beacon periodically.
 */
void
tsch_send_eb()
{
  /* [Mavi Alp Research Proprietary Code Redacted] */
}

/*------------------------------------------------------------------------------------------
* The local oscilator differences can desynchronize the nodes. Keep alive packets 
* are used the periodically resynchronize the node to their time masters
*/
#if FOURE_KA_ENABLE
void
tsch_send_ka()
{
 /* [Mavi Alp Research Proprietary Code Redacted] */
}
#endif /* FOURE_KA_ENABLE */

/*-------------------------------------------------------------------------------------------
 * Insert enhanced beacon to the 6TOP buffer for transmission, Check the node parent
 * periodically to see if the node is still synched. If you have lost synchronisation, resynch.
 */
PROCESS_THREAD(foure_timesynch_process, ev, data)
{
 /* [Mavi Alp Research Proprietary Code Redacted] */
}

#if INIT_RADIO_POLL_MODE_DURING_BOOT
/* Scanning protothread, called by foure_timesynch_hopping_process:
 * Listen to different channels, and when receiving an EB,
 * attempt to associate.
 */
PT_THREAD(tsch_scan(struct pt *pt))
{
/* [Mavi Alp Research Proprietary Code Redacted] */  
}
#endif /* INIT_RADIO_POLL_MODE_DURING_BOOT */

/*------------------------------------------------------------------------------
 * Channel Hopping Process hops between the channels to receive the beacon frame
 * and synchronise with the network. The scan duration is chosen arbitrarirly
 */
PROCESS_THREAD(foure_timesynch_hopping_process, ev, data)
{
/* [Mavi Alp Research Proprietary Code Redacted] */
}

#if FOURE_ADHOC_SYNC_ENABLED
/*------------------------------------------------------------------------------
 * Ad-Hoc Sync Process: periodically broadcasts fake data beacons
 * regardless of TSCH sync state.
 */
PROCESS_THREAD(foure_adhoc_sync_process, ev, data)
{
  static struct etimer adhoc_timer;

  PROCESS_BEGIN();

  LOG_INFO("AdHoc Sync Process Started\n");
  foure_adhoc_sync_init();

  etimer_set(&adhoc_timer, FOURE_ADHOC_SYNC_INTERVAL);

  while(1) {
    PROCESS_WAIT_EVENT_UNTIL(etimer_expired(&adhoc_timer));

    foure_adhoc_sync_send();
    foure_adhoc_sync_print_table();

    /* Jitter */
    etimer_set(&adhoc_timer, FOURE_ADHOC_SYNC_INTERVAL + (random_rand() % (5 * CLOCK_SECOND)));
  }

  PROCESS_END();
}
#endif /* FOURE_ADHOC_SYNC_ENABLED */

/*------------------------------------------------------------------------------
 * Initialisation of time synchronisation process. The beacons are scheduled to
 * be sent in the first slot of the slot frame.
 */
void
foure_timesynch_init(int8_t synched_to_master)
{
/* [Mavi Alp Research Proprietary Code Redacted] */

#if FOURE_ADHOC_SYNC_ENABLED
  /* Start Ad-Hoc Sync process */
  process_exit(&foure_adhoc_sync_process);
  process_start(&foure_adhoc_sync_process, NULL);
#endif /* FOURE_ADHOC_SYNC_ENABLED */

  if(SIXTOP_PCE.init != NULL){
    SIXTOP_PCE.init(synched_to_master);
  }
#if SIX_TISCH_SECURE_JOIN
  secure_join_init(foure_control.authenticated);
#endif /* SIX_TISCH_SECURE_JOIN */
#if PLATFORM_HAS_OTA_SYS && SIXTOP_OTA_ENABLED
  sixtop_ota_process_init();
#endif
}
/*------------------------------------------------------------------------------*/
#endif /* TSCH_TIME_SYNCH */
