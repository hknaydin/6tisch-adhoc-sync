/*
 * Copyright (c) 2024, Mavialp Research Limited.
 * All rights reserved.
 *
 * 4emac-adhoc-sync.h
 * Ad-Hoc Data Synchronization via Fake Beacon Broadcast
 *
 * Nodes broadcast their own data and data received from neighbors
 * using beacon-like frames with magic bytes (0xAD, 0x0C) to
 * distinguish from real EBs. Works both before and after TSCH sync.
 */
 * \author
 *         Ahmet Faruk Yavuz <ahmfrk61@gmail.com>
 *
 *         Sedat Gormus <sedatgormus@gmail.com>
 *
 *         Hakan AYDIN <hakayd28@gmail.com>
 */
   
#ifndef FOURE_ADHOC_SYNC_H_
#define FOURE_ADHOC_SYNC_H_

#ifndef FOURE_ADHOC_SYNC_MAX_TTL
#define FOURE_ADHOC_SYNC_MAX_TTL 64
#endif

#include "contiki.h"

/* Ad-Hoc Sync node entry */
typedef struct {
  uint16_t node_id;       /* Node ID (link-layer short address) */
  uint32_t seq;           /* Sequence number (version control) */
  uint8_t ttl;            /* Time-to-Live (Hop limit) */
  clock_time_t local_timestamp; /* Last update timestamp (local clock, NEVER transmitted) */
} adhoc_node_entry_t;

#if FOURE_ADHOC_SYNC_ENABLED

/* Initialize the adhoc sync module (table + own entry) */
void foure_adhoc_sync_init(void);

/* Create a fake data beacon frame into buf.
 * Returns total frame length, or 0 on error. */
uint8_t foure_adhoc_sync_create_frame(uint8_t *buf, uint8_t buf_size);

/* Check if a raw frame buffer is our adhoc sync frame (magic bytes check).
 * Returns 1 if adhoc frame, 0 otherwise. */
uint8_t foure_adhoc_sync_is_adhoc_frame(const uint8_t *buf, uint8_t buf_size);

/* Parse a received adhoc sync frame and update local table.
 * Returns 1 on success, 0 on error. */
uint8_t foure_adhoc_sync_parse_frame(const uint8_t *buf, uint8_t buf_size);

/* Send adhoc sync frame.
 * If synched  -> enqueue to shared slot (like EB)
 * If !synched -> send directly via NETSTACK_RADIO */
void foure_adhoc_sync_send(void);

/* Increment own sequence number */
void foure_adhoc_sync_update_seq(void);

/* Print table for Cooja debugging */
void foure_adhoc_sync_print_table(void);

#endif /* FOURE_ADHOC_SYNC_ENABLED */
#endif /* FOURE_ADHOC_SYNC_H_ */
