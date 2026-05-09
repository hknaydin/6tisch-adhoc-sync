/*
 * Copyright (c) 2010, Mavialp Research Limited.
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
 * Author: Sedat Gormus <sedatgormus@gmail.com>
 *
 */
#ifndef FOUREMAC_BUF_H_
#define FOUREMAC_BUF_H_

#if TRACKING_ENABLED
#include "6top-pce/6p-tracking.h"
#endif /* TRACKING_ENABLED */
#include "6top-pce/6p-queue.h"

#ifdef FOURE_CONF_MAC_MIN_BE
#define FOURE_MAC_MIN_BE FOURE_CONF_MAC_MIN_BE
#else
#define FOURE_MAC_MIN_BE 1
#endif

#ifdef FOURE_CONF_MAC_MAX_BE
#define FOURE_MAC_MAX_BE FOURE_CONF_MAC_MAX_BE
#else
#define FOURE_MAC_MAX_BE 5 //maximum 5 retries * 2 increments + min_be
#endif

#ifdef FOURE_CONF_MAC_BE_INC
#define FOURE_MAC_BE_INC FOURE_CONF_MAC_BE_INC
#else
#define FOURE_MAC_BE_INC 2
#endif

#define SLOT_RESERVED  0x20 // 0b0010 0000
#define SLOT_LOCK      0x40 // 0b0100 0000
#define SLOT_UNLOCK    0x80 // 0b1000 0000
#define SLOT_LOCK_ALL  (SLOT_UNLOCK | SLOT_LOCK | SLOT_RESERVED)

/* slot types */
#define SLOT_TYPE_TRANSMIT  0x01 // 0b0000 0001
#define SLOT_TYPE_RECEIVE   0x02 // 0b0000 0010
#define SLOT_TYPE_SHARED    0x04 // 0b0000 0100
#define SLOT_TYPE_TIMEKEEP  0x08 // 0b0000 1000
#define SLOT_TYPE_6P_CMD    0x20 // 0b0010 0000 // CELL_TYPE_TRACK_TRANSMIT
#define SLOT_TYPE_6P_LIST   0x40 // 0b0100 0000 // CELL_TYPE_TRACK_RECEIVE

#define SLOT_TYPE_HARD      (SLOT_TYPE_SHARED | SLOT_TYPE_TIMEKEEP | SLOT_TYPE_6P_CMD | SLOT_TYPE_6P_LIST)
#define SLOT_TYPE_ALL       (SLOT_TYPE_TRANSMIT | SLOT_TYPE_RECEIVE | SLOT_TYPE_HARD)

/* return types for slots */
/* [Mavi Alp Research Proprietary Code Redacted] */


/* buffer priorities */
/* [Mavi Alp Research Proprietary Code Redacted] */


/* return values */
/* [Mavi Alp Research Proprietary Code Redacted] */


#define FOURE_SLOT_INFINITE_LIFETIME 0xFFFFFFFF
#define FOURE_SLOT_LIFETIME 600

#define CN_LOCK   1
#define CN_UNLOCK 2

#ifndef SLOT_BUNDLE_CONF_NUM
#define SLOT_BUNDLE_NUM 3 // if we need 30ms then the value is 3 for 10ms slot duration, 2 for 15ms slot duration
#else /* SLOT_BUNDLE_CONF_NUM */
#define SLOT_BUNDLE_NUM SLOT_BUNDLE_CONF_NUM
#endif /* SLOT_BUNDLE_CONF_NUM */

#ifndef SLOT_CONF_NUM_FOR_EACH_PAGE_ERASE
#define SLOT_NUM_FOR_EACH_PAGE_ERASE 3 // if we need 30ms then the value is 3 for 10ms slot duration, 2 for 15ms slot duration
#else /* SLOT_NUM_FOR_EACH_PAGE_ERASE */
#define SLOT_NUM_FOR_EACH_PAGE_ERASE SLOT_CONF_NUM_FOR_EACH_PAGE_ERASE
#endif /* SLOT_CONF_NUM_FOR_EACH_PAGE_ERASE */


#define SLOT_BUNDLE_MAX 3
#if SLOT_BUNDLE_NUM > SLOT_BUNDLE_MAX
#error "SLOT_BUNDLE_NUM can't be greather than SLOT_BUNDLE_MAX!"
#endif

typedef struct scell{
/* [Mavi Alp Research Proprietary Code Redacted] */
} scell_t;

typedef struct slot{
/* [Mavi Alp Research Proprietary Code Redacted] */
} slot_t;

typedef struct content_buf {
/* [Mavi Alp Research Proprietary Code Redacted] */
} content_buf_t;

typedef struct content {
  struct content *next;
/* [Mavi Alp Research Proprietary Code Redacted] */
} content_t;

typedef struct destination {
/* [Mavi Alp Research Proprietary Code Redacted] */
} destination_t;

typedef struct destination_stat{
/* [Mavi Alp Research Proprietary Code Redacted] */
} destination_stat_t;

struct foure_buf_item {
/* [Mavi Alp Research Proprietary Code Redacted] */
};

/*------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/**
 * \brief  
 */
void foure_mac_buf_init();

/**
 * \brief   
 */
void foure_mac_buf_slot_backoff_reset(slot_t *sl);

/**
 * \brief   
 */
void foure_mac_buf_slot_backoff_inc(slot_t *sl);

/**
 * \brief   
 */
void foure_mac_buf_slot_update_backoff_window(uint8_t slot_offset);

/*------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/**
 * \brief
 * \retval     
 */
uint8_t foure_mac_buf_destination_stats_register(struct memb *m);

/**
 * \brief
 * \retval     
 */
destination_stat_t * foure_mac_buf_destination_stat_get(struct memb *m, destination_t *dn);

/*------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/**
 * \brief
 * \retval     
 */
destination_t * foure_mac_buf_destination_get_head();

/**
 * \brief
 * \retval     
 */
destination_t * foure_mac_buf_destination_get(linkaddr_t *linkaddr);

/**
 * \brief
 * \retval     
 */
const linkaddr_t * foure_mac_buf_destination_get_linkaddr(destination_t *dn);

/**
 * \brief   
 */
void foure_mac_buf_destination_set_callback(linkaddr_t *linkaddr, mac_callback_t sent);

/*------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/**
 * \brief     
 * \retval    
 */
slot_t * foure_mac_buf_slot_head(destination_t *dn);

/**
 * \brief   
 * \retval       
 */
slot_t * foure_mac_buf_slot_head_from_linkaddr(linkaddr_t *linkaddr);

/**
 * \brief 
 * \retval     
 */
slot_t * foure_mac_buf_slot_get(destination_t *dn, uint8_t slot_offset);

/**
 * \brief     get the number of slots until the next scheduled slot
 * \retval     
 */
uint8_t foure_mac_buf_slot_get_next_scheduled(uint8_t slot_offset, uint8_t frame_size);

/**
 * \brief 
 * \retval     
 */
uint8_t foure_mac_buf_slot_schedule(linkaddr_t *linkaddr, uint8_t slot_type, uint8_t slot_lock, uint8_t slot_offset, uint8_t channel_offset, unsigned long life_time);

/**
 * \brief     remove given slot from the destination list.
 */
void foure_mac_buf_slot_unschedule(linkaddr_t *linkaddr, uint8_t slot_offset);

/**
 * \brief 
 * \retval     
 */
uint8_t foure_mac_buf_slot_get_num_from_linkaddr(linkaddr_t *linkaddr, uint8_t slot_type, uint8_t slot_lock);

/**
 * \brief  Returns the number of contents with priority less than or equak to priority parameter destined for linkaddr
 * \retval Number of frames with priority less than or equal to priority parameter
 */
uint8_t foure_mac_buf_content_get_frames_with_priority(linkaddr_t *linkaddr, uint8_t priority);

/**
 * \brief
 * \retval
 */
uint8_t foure_mac_buf_get_slot_offset_to_skip_bundle();

/**
 * \brief     
 * \retval    
 */
uint16_t foure_mac_buf_slot_get_stat_from_linkaddr(linkaddr_t *linkaddr, uint8_t slot_type, uint8_t slot_lock, uint8_t stat_type);

/**
 * \brief     
 * \retval    
 */
uint16_t foure_mac_buf_slot_inc_rx_from_linkaddr(linkaddr_t *linkaddr, uint8_t slot_offset);

/*------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/**
 * \brief     
 * \retval    
 */
content_t * foure_mac_buf_content_get_from_packet_type(destination_t *dn, uint8_t content_type);

/**
 * \brief      Copy data with content type to the destinations content buffer
 * \retval     foure return values
 */
uint8_t foure_mac_buf_content_insert_data(linkaddr_t *linkaddr, uint8_t *buf, uint8_t buf_len, uint8_t hdr_len, uint8_t content_type, uint8_t slot_type, uint8_t seqno, uint8_t priority, void *ptr, void *t_ptr);

/**
 * \brief     get the content and destination for the current slot
 * \retval     
 */
uint8_t foure_mac_buf_content_get_scheduled(destination_t **dn, content_t **cn, slot_t **sl, uint8_t slot_offset);

/**
 * \brief     Remove given content from the destination list.
 */
void foure_mac_buf_content_delete(destination_t *dn, content_t *cn);

/**
 * \brief 
 */
void foure_mac_buf_content_delete_for_packet_type(linkaddr_t *linkaddr, uint8_t content_type);

/**
 * \brief   
 */
uint8_t foure_mac_buf_content_get_num_from_linkaddr(linkaddr_t *linkaddr);

/**
 * \brief      
 * \retval     
 */
uint8_t foure_mac_buf_content_get_free_num();

/**
 * \brief     
 * \retval    
 */
uint8_t foure_mac_buf_content_get_buffer_occupancy(linkaddr_t *linkaddr);

/*------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/**
 * \brief     
 */
void foure_mac_buf_parent_changed(linkaddr_t *old_parent, linkaddr_t *new_parent);

#if TRACKING_ENABLED
/**
 * \brief     
 * \retval    
 */
uint8_t foure_mac_buf_schedule_track(linkaddr_t *linkaddr, track_t *t, uint8_t slot_offset);
/**
 * \brief     
 * \retval    
 */
track_t * foure_mac_buf_get_track(linkaddr_t *linkaddr, uint8_t slot_offset, uint8_t slot_type, uint8_t slot_lock);
/**
 * \brief     
 * \retval    
 */
linkaddr_t * foure_mac_buf_get_track_linkaddr(track_t *t, uint8_t slot_type, uint8_t slot_lock);
#endif /* TRACKING_ENABLED */

#endif /* FOUREMAC_BUF_H_ */
