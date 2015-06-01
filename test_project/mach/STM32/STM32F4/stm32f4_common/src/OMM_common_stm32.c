/*
 * OMM_common_stm32f4.c
 *
 *  Created on: Feb 27, 2015
 *      Author: fflasch
 */

#include <stdint.h>
#include <stdlib.h>
#include <stm32f4xx.h>
#include <stm32f4xx_conf.h>

void OMM_busy_delay(__IO uint64_t val)
{
	uint64_t i = 0;
	uint64_t j = 0;
	for(j=0;j<(val*1400);j++)
		for(i=0;i<1000000;i++);
}
