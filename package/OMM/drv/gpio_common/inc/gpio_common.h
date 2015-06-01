/*
 * gpio_common.h
 *
 *  Created on: Feb 26, 2015
 *      Author: fflasch
 */

#ifndef GPIO_COMMON_H_
#define GPIO_COMMON_H_


/*
 * spi_common.h
 *
 *  Created on: Feb 14, 2015
 *      Author: franz
 */

#include <stdint.h>

#define GPIO_COMMON_LOW 0
#define GPIO_COMMON_HIGH 1

typedef struct gpio_controller_s gpio_controller_t;

typedef enum gpio_mode
{
	ACTIVE_LOW,
	ACTIVE_HIGH

}gpio_mode_e;

struct gpio_controller_s
{
	uint8_t mode;
	uint8_t nrpins;
	void (*GPIO_set)(gpio_controller_t *gpio, uint8_t pin, uint8_t val);
	void *platform_drv_info;
};

void GPIO_init_controller(gpio_controller_t *controller,
						  gpio_mode_e mode,
						  uint8_t nrpins,
					 	  void *gpio_set,
						  void *platform_drv_info);

void GPIO_set(gpio_controller_t *gpio, uint8_t pin, uint8_t val);

#endif /* GPIO_COMMON_H_ */
