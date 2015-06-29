/*
 * spi_common.h
 *
 *  Created on: Feb 14, 2015
 *      Author: franz
 */

#ifndef SPI_COMMON_H_
#define SPI_COMMON_H_

#include <stdint.h>

#define SPI_COMMON_LOW 0
#define SPI_COMMON_HIGH 1

typedef enum spi_mode
{
	MODE_0_0,
	MODE_1_1

}spi_mode_e;

typedef struct spi_device_s spi_device_t;
typedef struct spi_master_s spi_master_t;

struct spi_master_s
{
	void (*SPI_set_cs)(spi_device_t *spi, uint8_t val);
	uint8_t (*SPI_transfer_byte)(spi_device_t *spi, uint8_t byte);
	void (*SPI_transfer_msg)(spi_device_t *spi, uint8_t *data_out, uint8_t *data_in, uint16_t len);
	uint8_t (*SPI_transfer_byte_cs_off)(spi_device_t *spi, uint8_t byte);
	void *platform_drv_info;
};

struct spi_device_s
{
	uint8_t mode;
	uint8_t pin;
	spi_master_t *spi_master;
};

void SPI_init_master(spi_master_t *master,
					 void *spi_set_cs,
					 void *spi_trans_byte_cb_cs_off,
					 void *spi_trans_byte_cb_cs_on,
					 void *spi_trans_msg,
					 void *platform_drv_info);
void SPI_init_device(spi_device_t *spi_dev, uint8_t mode, uint8_t pin, spi_master_t *master);

uint8_t SPI_transfer_byte(spi_device_t *spi, uint8_t val);
uint8_t SPI_transfer_byte_cs_off(spi_device_t *spi, uint8_t val);
void SPI_transfer_msg(spi_device_t *spi, uint8_t *data_out, uint8_t *data_in, uint16_t len);
void SPI_set_cs(spi_device_t *spi, uint8_t val);

#endif /* SPI_COMMON_H_ */
