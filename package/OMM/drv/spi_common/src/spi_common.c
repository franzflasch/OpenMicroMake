/*
 * spi_common.c
 *
 *  Created on: Feb 14, 2015
 *      Author: franz
 */

#include <spi_common.h>

void SPI_init_master(spi_master_t *master, 
					 void *spi_set_cs,
					 void *spi_trans_byte_cb_cs_off, 
					 void *spi_trans_byte_cb_cs_on, 
					 void *spi_trans_msg,
					 void *platform_drv_info)
{
	master->SPI_set_cs = spi_set_cs;

	master->SPI_transfer_byte = spi_trans_byte_cb_cs_on;
	master->SPI_transfer_byte_cs_off = spi_trans_byte_cb_cs_off;

	master->SPI_transfer_msg = spi_trans_msg;

	master->platform_drv_info = platform_drv_info;
}

void SPI_init_device(spi_device_t *spi_dev, uint8_t mode, uint8_t pin, spi_master_t *master)
{
	spi_dev->mode = mode;
	spi_dev->pin = pin;
	spi_dev->spi_master = master;
}

uint8_t SPI_transfer_byte(spi_device_t *spi, uint8_t val)
{
	return spi->spi_master->SPI_transfer_byte(spi, val);
}

void SPI_transfer_msg(spi_device_t *spi, uint8_t *data_out, uint8_t *data_in, uint16_t len)
{
	spi->spi_master->SPI_transfer_msg(spi, data_out, data_in, len);
}

uint8_t SPI_transfer_byte_cs_off(spi_device_t *spi, uint8_t val)
{
	return spi->spi_master->SPI_transfer_byte_cs_off(spi, val);
}

void SPI_set_cs(spi_device_t *spi, uint8_t val)
{
	return spi->spi_master->SPI_set_cs(spi, val);
}



