/*
 * Copyright (c) 2024, Mavialp Research Limited.
 * All rights reserved.
 *
 * 4emac-adhoc-sync.c
 * Ad-Hoc Data Synchronization via Fake Beacon Broadcast
 *
 * Creates and parses beacon-like frames carrying node sync data.
 * Magic bytes (0xAD, 0x0C) distinguish these from real EBs.
 * Works both in scanning (pre-sync) and slotted (post-sync) modes.
 */

 * \author
 *
 *         Sedat Gormus <sedatgormus@gmail.com>
 *
 *         Hakan AYDIN <hakayd28@gmail.com>
 */
#include "contiki.h"

#if TSCH_TIME_SYNCH
#include "net/mac/4emac/4emac-private.h"
#include "net/mac/4emac/4emac-adhoc-sync.h"
#include "net/mac/framer/frame802154.h"
#include "sys/node-id.h"
#include <string.h>

#if FOURE_ADHOC_SYNC_ENABLED

#include "sys/log.h"
#define LOG_MODULE "4EMAC-ADHOC"
#ifndef LOG_CONF_LEVEL_4EMAC
#define LOG_LEVEL LOG_LEVEL_INFO
#else
#define LOG_LEVEL LOG_CONF_LEVEL_4EMAC
#endif

/*---------------------------------------------------------------------------*/
/* Node table: stores known nodes' IDs and sequence numbers */
static adhoc_node_entry_t adhoc_sync_table[FOURE_ADHOC_SYNC_MAX_NODES];
static uint32_t my_adhoc_seq = 0;

/*---------------------------------------------------------------------------*/
/* Find or allocate a table entry for the given node ID */
static adhoc_node_entry_t *
get_entry(uint16_t id)
{
  int i;
  /* 1. Find existing */
  for(i = 0; i < FOURE_ADHOC_SYNC_MAX_NODES; i++) {
    if(adhoc_sync_table[i].node_id == id) {
      return &adhoc_sync_table[i];
    }
  }
  /* 2. Find empty slot */
  for(i = 0; i < FOURE_ADHOC_SYNC_MAX_NODES; i++) {
    if(adhoc_sync_table[i].node_id == 0) {
      adhoc_sync_table[i].node_id = id;
      return &adhoc_sync_table[i];
    }
  }
  return NULL; /* Table full */
}

/*---------------------------------------------------------------------------*/
/* Serialize the node table into a buffer.
 * Format: [count(1)] [node_id(2) | seq(4) | ttl(1)] ...
 * Returns the total payload length written. */
static uint8_t
serialize_table(uint8_t *buf)
{
  uint8_t count = 0;
  uint8_t *ptr = buf + 1; /* skip count byte */
  int max_payload = 100;  /* safe limit for 802.15.4 frame */
  int current_len = 1;
  int i;

  /* Always include myself first */
  adhoc_node_entry_t *me = get_entry(node_id);
  if(me) {
    me->ttl = FOURE_ADHOC_SYNC_MAX_TTL; /* Reset my own TTL on broadcast */
    memcpy(ptr, &me->node_id, 2); ptr += 2;
    memcpy(ptr, &me->seq, 4); ptr += 4;
    memcpy(ptr, &me->ttl, 1); ptr += 1;
    count++;
    current_len += 7;
  }

  /* Add other known nodes */
  for(i = 0; i < FOURE_ADHOC_SYNC_MAX_NODES; i++) {
    if(adhoc_sync_table[i].node_id != 0 && adhoc_sync_table[i].node_id != node_id) {
      uint8_t send_ttl = adhoc_sync_table[i].ttl;
      if(send_ttl > 0) {
        send_ttl--; /* Decrement TTL before sending */
      }
      
      if(send_ttl > 0) { /* Only send if TTL is still valid */
        if(current_len + 7 > max_payload) break;
        memcpy(ptr, &adhoc_sync_table[i].node_id, 2); ptr += 2;
        memcpy(ptr, &adhoc_sync_table[i].seq, 4); ptr += 4;
        memcpy(ptr, &send_ttl, 1); ptr += 1;
        count++;
        current_len += 7;
      }
    }
  }

  buf[0] = count;
  return current_len;
}

/*---------------------------------------------------------------------------*/
void
foure_adhoc_sync_init(void)
{
  memset(adhoc_sync_table, 0, sizeof(adhoc_sync_table));
  adhoc_node_entry_t *me = get_entry(node_id);
  if(me) {
    me->seq = 1;
    me->ttl = FOURE_ADHOC_SYNC_MAX_TTL;
    me->local_timestamp = clock_time();
  }
  my_adhoc_seq = 1;
  LOG_INFO("Ad-Hoc Sync initialized, node_id=%u\n", node_id);
}

/*---------------------------------------------------------------------------*/
void
foure_adhoc_sync_update_seq(void)
{
  adhoc_node_entry_t *me = get_entry(node_id);
  if(me) {
    me->seq = ++my_adhoc_seq;
    me->ttl = FOURE_ADHOC_SYNC_MAX_TTL;
    me->local_timestamp = clock_time();
  }
}

/*---------------------------------------------------------------------------*/
/* Create fake data beacon frame.
 * Uses the same 802.15.4 beacon header as a real EB, but with ie_list_present=0
 * and magic bytes (0xAD, 0x0C) right after the header followed by
 * the serialized node table.
 *
 * Frame layout:
 * [802.15.4 Beacon Hdr] [0xAD] [0x0C] [count] [id(2)|seq(4)] ...
 *
 * Returns total frame length or 0 on error.
 */
uint8_t
foure_adhoc_sync_create_frame(uint8_t *buf, uint8_t buf_size)
{
  int curr_len = 0;
  frame802154_t p;

  if(buf_size < FOURE_MAC_MAX_PACKET_LEN) {
    return 0;
  }

  /* Create 802.15.4 header - same structure as EB */
  memset(&p, 0, sizeof(p));
  p.fcf.frame_type = FRAME802154_ADHOCFRAME;
  p.fcf.ie_list_present = 0;  /* No IEs, raw payload instead */
  p.fcf.frame_version = FRAME802154_IEEE802154_2015;
  p.fcf.src_addr_mode = LINKADDR_SIZE > 2 ? FRAME802154_LONGADDRMODE : FRAME802154_SHORTADDRMODE;
  p.fcf.dest_addr_mode = FRAME802154_SHORTADDRMODE;
  p.fcf.sequence_number_suppression = 1;
  p.fcf.panid_compression = 0;

  p.src_pid = frame802154_get_pan_id();
  p.dest_pid = frame802154_get_pan_id();
  linkaddr_copy((linkaddr_t *)&p.src_addr, &linkaddr_node_addr);
  p.dest_addr[0] = 0xff;  /* Broadcast */
  p.dest_addr[1] = 0xff;

  if((curr_len = frame802154_create(&p, buf)) == 0) {
    return 0;
  }

  /* Serialize the node table as payload directly after header */
  uint8_t payload_len = serialize_table(buf + curr_len);
  curr_len += payload_len;

  return curr_len;
}

/*---------------------------------------------------------------------------*/
/* Check if a raw frame is our adhoc sync frame.
 * Simply checks the frame_type field in the FCF. */
uint8_t
foure_adhoc_sync_is_adhoc_frame(const uint8_t *buf, uint8_t buf_size)
{
  frame802154_fcf_t fcf;

  if(buf_size < 2) {
    return 0;
  }

  frame802154_parse_fcf((uint8_t *)buf, &fcf);
  return (fcf.frame_type == FRAME802154_ADHOCFRAME) ? 1 : 0;
}

/*---------------------------------------------------------------------------*/
/* Parse a received adhoc sync frame and update the local table.
 * Re-creates the same header to find exact payload offset.
 * Returns 1 on success, 0 on error. */
uint8_t
foure_adhoc_sync_parse_frame(const uint8_t *buf, uint8_t buf_size)
{
  /* Re-create the same header structure to get exact header length */
  uint8_t tmp[FOURE_MAC_MAX_PACKET_LEN];
  frame802154_t p;
  int hdr_len;

  memset(&p, 0, sizeof(p));
  p.fcf.frame_type = FRAME802154_ADHOCFRAME;
  p.fcf.ie_list_present = 0;
  p.fcf.frame_version = FRAME802154_IEEE802154_2015;
  p.fcf.src_addr_mode = LINKADDR_SIZE > 2 ? FRAME802154_LONGADDRMODE : FRAME802154_SHORTADDRMODE;
  p.fcf.dest_addr_mode = FRAME802154_SHORTADDRMODE;
  p.fcf.sequence_number_suppression = 1;
  p.fcf.panid_compression = 0;
  p.src_pid = frame802154_get_pan_id();
  p.dest_pid = frame802154_get_pan_id();

  hdr_len = frame802154_create(&p, tmp);
  if(hdr_len == 0) {
    LOG_ERR("parse_frame: header length error\n");
    return 0;
  }

  /* Payload starts right after header (no magic bytes needed) */
  if(hdr_len >= buf_size) {
    LOG_ERR("parse_frame: hdr_len=%d >= buf_size=%d\n", hdr_len, buf_size);
    return 0;
  }

  const uint8_t *payload = buf + hdr_len;
  uint8_t count = payload[0];
  const uint8_t *ptr = payload + 1;
  int i;

  LOG_INFO("Received adhoc frame, hdr=%d, entries=%u\n", hdr_len, count);

  for(i = 0; i < count; i++) {
    uint16_t id;
    uint32_t seq;
    uint8_t ttl;

    if((ptr - buf) + 7 > buf_size) break;

    memcpy(&id, ptr, 2); ptr += 2;
    memcpy(&seq, ptr, 4); ptr += 4;
    memcpy(&ttl, ptr, 1); ptr += 1;

    if(id == node_id) continue;

    adhoc_node_entry_t *entry = get_entry(id);
    if(entry) {
      if(seq > entry->seq) {
        entry->seq = seq;
        entry->ttl = ttl;
        entry->local_timestamp = clock_time();
        LOG_DBG("Updated node %u seq=%lu ttl=%u\n", id, (unsigned long)seq, ttl);
      }
    }
  }

  foure_adhoc_sync_print_table();
  return 1;
}

/*---------------------------------------------------------------------------*/
/* Send the adhoc sync frame.
 * Synched   -> enqueue to MAC buffer for shared slot transmission (like EB)
 * !Synched  -> send directly via NETSTACK_RADIO (during scanning) */
void
foure_adhoc_sync_send(void)
{
  uint8_t buf[FOURE_MAC_MAX_PACKET_LEN];
  int len;

  foure_adhoc_sync_update_seq();

  len = foure_adhoc_sync_create_frame(buf, sizeof(buf));
  if(len <= 0) {
    LOG_ERR("Failed to create adhoc frame\n");
    return;
  }

  if(foure_control.synched) {
    /* Synched: enqueue for shared slot, just like tsch_send_eb() */
    frame802154_t frame;
    int hdr_len = frame802154_parse(buf, len, &frame);
    foure_mac_buf_content_insert_data(
      (linkaddr_t *)&linkaddr_null, buf, len, hdr_len,
      FRAME802154_ADHOCFRAME, SLOT_TYPE_SHARED, 0, PRIORITY_0, NULL, NULL);
    LOG_INFO("Adhoc frame enqueued to shared slot (len=%d)\n", len);
  } else {
    /* Not synched: direct radio send */
    NETSTACK_RADIO.send(buf, len);
    LOG_INFO("Adhoc frame sent via radio (len=%d)\n", len);
  }

  /* Debug: hex dump of transmitted frame */
  {
    int i;
    LOG_INFO("ADHOC TX [%d]: ", len);
    for(i = 0; i < len; i++) {
      LOG_INFO_("%02x ", buf[i]);
    }
    LOG_INFO_("\n");
  }
}

/*---------------------------------------------------------------------------*/
/* Print the sync table - useful for Cooja test scripts */
void
foure_adhoc_sync_print_table(void)
{
  int i, target_id;

  printf("ADHOC_SYNC: %u", node_id);
  for(target_id = 1; target_id <= FOURE_ADHOC_SYNC_MAX_NODES; target_id++) {
    uint32_t seq = 0;
    for(i = 0; i < FOURE_ADHOC_SYNC_MAX_NODES; i++) {
      if(adhoc_sync_table[i].node_id == target_id) {
        seq = adhoc_sync_table[i].seq;
        break;
      }
    }
    if(seq > 0) {
      printf(" [%u:%lu]", target_id, (unsigned long)seq);
    }
  }
  printf("\n");
}

/*---------------------------------------------------------------------------*/
#endif /* FOURE_ADHOC_SYNC_ENABLED */
#endif /* TSCH_TIME_SYNCH */
