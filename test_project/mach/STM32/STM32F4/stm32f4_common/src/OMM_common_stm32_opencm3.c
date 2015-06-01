/*
 * OMM_common_stm32f4.c
 *
 *  Created on: Feb 27, 2015
 *      Author: fflasch
 */

#include <stdint.h>
#include <stdlib.h>
#include <OMM_machine_common.h>

void OMM_busy_delay(uint64_t val)
{
	uint64_t i = 0;
	for (i = 0; i < val*500; i++) {	/* Wait a bit. */
		__asm__("nop");
	}
}
