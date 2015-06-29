#ifndef _SOFT_SPI_H
#define _SOFT_SPI_H

#include <stdint.h>
#include <spi_common.h>

#define SOFT_SPI_LOW 0
#define SOFT_SPI_HIGH 1

/* software spi interface */
typedef struct soft_spi_s
{
	spi_device_t *pdev;
	void (*set_mosi)(uint8_t val);
	uint8_t (*get_miso)(void);
	void (*set_clk)(uint8_t val);
	void (*set_cs)(uint8_t val, uint8_t pin);
}soft_spi_t;

void SOFT_SPI_set_cs(spi_device_t *spi, uint8_t val);
uint8_t SOFT_SPI_transfer_byte_CS_off(spi_device_t *spi, uint8_t byte);
uint8_t SOFT_SPI_transfer_byte_CS_on(spi_device_t *spi, uint8_t byte);
void SOFT_SPI_transfer_msg(spi_device_t *spi, uint8_t *data_out, uint8_t *data_in, uint16_t len);

#endif // header
