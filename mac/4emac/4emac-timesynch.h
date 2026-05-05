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
#ifndef FOURE_TIMESYNCH_H_
#define FOURE_TIMESYNCH_H_

#include "contiki.h"
#include "net/routing/rpl-classic/rpl-private.h"
#include "net/routing/rpl-classic/rpl-dag-root.h"
#include "net/mac/4emac/4emac-time-master.h"

#define CONTROL_CHANNEL       26
#define PARENT_LOST_TRESHOLD  (10 * MAX_EB_INTERVAL_MUL)

#define MIN_AUTHORITY_LEVEL 0x00
#define MAX_AUTHORITY_LEVEL 0XFF

struct foure_mac_control {
  uint8_t master;
  uint8_t synched;
  uint8_t secured;
  uint8_t authenticated;
};

/**
 * \brief      Initialize the timesynch module
 *
 *             This function initializes the timesynch module. This
 *             function must not be called before rime_init().
 *
 */
void foure_timesynch_init(int8_t);

/**
 * \brief      Get the current authority level of the time-synchronized time
 * \return     The current authority level of the time-synchronized time
 *
 *             This function returns the current authority level of
 *             the time-synchronized time. A node with a lower
 *             authority level is defined to have a better notion of
 *             time than a node with a higher authority
 *             level. Authority level 0 is best and should be used by
 *             a sink node that has a connection to an outside,
 *             "true", clock source.
 *
 */
uint8_t tsch_timesynch_authority_level(void);

/**
 * \brief      Set the authority level of the current time
 * \param      level The authority level
 */
void tsch_timesynch_set_authority_level(uint8_t level);

/**
 * \brief      Receive the timing update from the parent authority
 * \param      node
 */
void tsch_eb_input();

#define P23_OUT() P2DIR |= BV(3)
#define P23_IN() P2DIR &= ~BV(3)
#define P23_SEL() P2SEL &= ~BV(3)
#define P23_IS_1  (P2OUT & BV(3))
#define P23_WAIT_FOR_1() do{}while (!P23_IS_1)
#define P23_IS_0  (P2OUT & ~BV(3))
#define P23_WAIT_FOR_0() do{}while (!P23_IS_0)
#define P23_1() P2OUT |= BV(3)
#define P23_0() P2OUT &= ~BV(3)
#endif /* FOURE_TIMESYNCH_H_ */
