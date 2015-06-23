/*
 * OMM_common_avr.c
 *
 *  Created on: Feb 27, 2015
 *      Author: fflasch
 */

#include <avr/io.h>
#include <util/delay.h>
#include <stdint.h>

void OMM_busy_delay(uint64_t val)
{
	uint64_t i = 0;
	for(i=0;i<val;i++)
	{
		/* Expects a constant */
		_delay_ms(1);
	}
}
