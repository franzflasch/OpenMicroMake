/*
 * OMM_machine_common.c
 *
 *  Created on: Feb 24, 2015
 *      Author: fflasch
 */

#include <OMM_machine_common.h>
#include <gpio_common.h>
#include <string.h>

void *OMM_get_pdev_by_name(OMM_machine_t *machine, char *name)
{
	OMM_platform_devices *pdev = machine->pdev_list;

	while(pdev->name != 0)
	{
		if (strcmp(pdev->name,name) == 0)
			break;
		pdev++;
	}

	return pdev->pdev;
}

