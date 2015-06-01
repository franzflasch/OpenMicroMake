/*
 * gpio_common.c
 *
 *  Created on: Feb 26, 2015
 *      Author: fflasch
 */

/*
 * spi_common.c
 *
 *  Created on: Feb 14, 2015
 *      Author: franz
 */

#include <gpio_common.h>

void GPIO_init_controller(gpio_controller_t *controller,
						  gpio_mode_e mode,
						  uint8_t nrpins,
					 	  void *gpio_set,
						  void *platform_drv_info)
{
	controller->mode = mode;
	controller->nrpins = nrpins;
	controller->GPIO_set = gpio_set;
	controller->platform_drv_info = platform_drv_info;
}

void GPIO_set(gpio_controller_t *gpio, uint8_t pin, uint8_t val)
{
	return gpio->GPIO_set(gpio, pin, val);
}

