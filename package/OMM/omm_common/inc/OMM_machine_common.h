/*
 * OMM_machine_common.h
 *
 *	"OpenMicroMake" Common machine description
 *
 *  Created on: Feb 24, 2015
 *      Author: fflasch
 */

#ifndef OMM_MACHINE_COMMON_H_
#define OMM_MACHINE_COMMON_H_

#include <stdint.h>

typedef struct OMM_platform_devices_s
{
	char *name;
	void *pdev;

}OMM_platform_devices;

typedef struct OMM_machine_desc_s
{
	/* Machine name */
	char *name;

	/* Common platform device list */
	OMM_platform_devices *pdev_list;

}OMM_machine_t;

void *OMM_get_pdev_by_name(OMM_machine_t *machine, char *name);

/* These functions are architecure specific and have to be defined externally */
OMM_machine_t *machine_setup(void);
void OMM_busy_delay(uint64_t val);

#endif /* OMM_MACHINE_COMMON_H_ */

