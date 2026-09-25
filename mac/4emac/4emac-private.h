#ifndef FOURE_PRIVATE_H_
#define FOURE_PRIVATE_H_

#include "contiki.h"
#include "contiki-lib.h"
#include "contiki-net.h"

/* 4emac MAC parameters */
/* [Mavi Alp Research Proprietary Code Redacted] */

/*MAC Drivers */

/* [Mavi Alp Research Proprietary Code Redacted] */

/*Send acknowledgement to the frames*/
/* [Mavi Alp Research Proprietary Code Redacted] */

// Boot in poll mode by default
/* [Mavi Alp Research Proprietary Code Redacted] */


/* Maximum length of the channel. Must be greater or
 * equal to the length of FOURE_DEFAULT_HOPPING_SEQUENCE. */
/* [Mavi Alp Research Proprietary Code Redacted] */

#define FOURE_HOPPING_SEQUENCE_16 (uint8_t[]){ 16, 17, 23, 18, 26, 15, 25, 22, 19, 11, 12, 13, 24, 14, 20, 21 }
#define FOURE_HOPPING_SEQUENCE_6 (uint8_t[]){ 26, 15, 22, 25, 11, 20 }
#define FOURE_HOPPING_SEQUENCE_5 (uint8_t[]){ 15, 22, 11, 20, 26 }
#define FOURE_HOPPING_SEQUENCE_5_868 (uint8_t[]){ 31, 33, 32, 30, 29 }

/* Default hopping sequence, used in case hopping sequence ID == 0 */
/* [Mavi Alp Research Proprietary Code Redacted] */

/* Foure Buffer */
/* [Mavi Alp Research Proprietary Code Redacted] */

extern uint8_t MIN_EB_INTERVAL_MUL;
extern uint8_t MAX_EB_INTERVAL_MUL;

#define MIN_BEACON_INTERVAL (MIN_EB_INTERVAL_MUL * CLOCK_SECOND)
#define MAX_BEACON_INTERVAL (MAX_EB_INTERVAL_MUL * CLOCK_SECOND)


/* Ad-Hoc Data Sync (Fake Beacon) */
#ifdef FOURE_CONF_ADHOC_SYNC_ENABLED
#define FOURE_ADHOC_SYNC_ENABLED FOURE_CONF_ADHOC_SYNC_ENABLED
#else
#define FOURE_ADHOC_SYNC_ENABLED 0
#endif /* FOURE_CONF_ADHOC_SYNC_ENABLED */

#ifdef FOURE_CONF_ADHOC_SYNC_INTERVAL
/* [Mavi Alp Research Proprietary Code Redacted] */
#endif

#define FOURE_ADHOC_SYNC_MAX_NODES 64

#ifdef FOURE_CONF_KA_INTERVAL
/* [Mavi Alp Research Proprietary Code Redacted] */
#endif

#define CLOCK_OFFSET_DRIFT_THRESHOLD ((0x4 * MAX_BEACON_INTERVAL) / CLOCK_SECOND)

/* Timeslot timing */
/* [Mavi Alp Research Proprietary Code Redacted] */

#else /* !FOURE_CONF_TIMESLOT_TIMING */
/* [Mavi Alp Research Proprietary Code Redacted] */


#if FOURE_DEFAULT_TIMESLOT_LENGTH == 10000
/* Default timeslot timing as per IEEE 802.15.4e */

/* [Mavi Alp Research Proprietary Code Redacted] */

#elif FOURE_DEFAULT_TIMESLOT_LENGTH == 15000
/* Default timeslot timing for platfroms requiring 15ms slots */

/* [Mavi Alp Research Proprietary Code Redacted] */

#elif FOURE_DEFAULT_TIMESLOT_LENGTH == 45000
/* Default timeslot timing for platfroms requiring 45ms slots
 * (e.g. sky/z1 with security enabled) */

/* [Mavi Alp Research Proprietary Code Redacted] */

#elif FOURE_DEFAULT_TIMESLOT_LENGTH == 65000
/* [Mavi Alp Research Proprietary Code Redacted] */
/* Max TSCH packet lenght - last bytes are CRC in default 802.15.4 packets */
#define TSCH_PACKET_MAX_LEN MIN(127 - 2, PACKETBUF_SIZE)

#if RTIMER_SECOND >= 200000
#define RTIMER_GUARD (RTIMER_SECOND / 100000)
#else
#define RTIMER_GUARD 2u
#endif

/* Convert rtimer ticks to clock and vice versa */
/* [Mavi Alp Research Proprietary Code Redacted] */

/* Calculate packet tx/rx duration in rtimer ticks based on sent
 * packet len in bytes with 802.15.4 250kbps data rate.
 * One byte = 32us. Add two bytes for CRC and one for len field */
#define TSCH_PACKET_DURATION(len) US_TO_RTIMERTICKS(32 * ((len) + 3))

/* Wait for a condition with timeout t0+offset. */
/* [Mavi Alp Research Proprietary Code Redacted] */

#if FOURE_ADHOC_SYNC_ENABLED
#include "net/mac/4emac/4emac-adhoc-sync.h"
#endif /* FOURE_ADHOC_SYNC_ENABLED */

extern struct foure_mac_control foure_control;
extern struct asn_t current_asn;

extern uint16_t slot_frame_size;

/* Current timeslot timing (in micro-second) */
/* [Mavi Alp Research Proprietary Code Redacted] */

/* Current timeslot timing (in rtimer-ticks) */
/* [Mavi Alp Research Proprietary Code Redacted] */

extern uint8_t foure_channel_hopping_pattern[];
extern uint8_t foure_channel_hopping_pattern_len;

extern scell_t hard_slots[];
extern uint8_t hard_slot_len;

extern const struct sixtop_pce_driver SIXTOP_PCE;

struct foure_mac_item {
  struct foure_buf_item buf_item;
  mac_callback_t sent;
  packetbuf_t *packetbuf;
  uint8_t status;
  uint8_t num_transmissions;
};

extern const linkaddr_t linkaddr_mcast;

#endif /* FOURE_PRIVATE_H_ */
