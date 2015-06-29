
#include <soft_spi.h>
#include <stdio.h>
#include <stdint.h>

/* a byte transfer in (0,0) mode */
static uint8_t SOFT_SPI_transfer_mode_0_0(soft_spi_t *spi, uint8_t byte)
{
	uint8_t counter;

	for(counter = 8; counter; counter--)
	{
		if (byte & 0x80)
			spi->set_mosi(SOFT_SPI_HIGH);
		else
			spi->set_mosi(SOFT_SPI_LOW);

		byte <<= 1;
		spi->set_clk(SOFT_SPI_HIGH);/* a slave latches input data bit */

		if (spi->get_miso())
			byte |= 0x01;

		spi->set_clk(SOFT_SPI_LOW); /* a slave shifts out next output data bit */
	}
	return(byte);
}

/* a byte transfer in (1,1) mode */
static uint8_t SOFT_SPI_transfer_mode_1_1(soft_spi_t *spi, uint8_t byte)
{
	uint8_t counter;

	for(counter = 8; counter; counter--)
	{
		if (byte & 0x80)
			spi->set_mosi(SOFT_SPI_HIGH);
		else
			spi->set_mosi(SOFT_SPI_LOW);

		spi->set_clk(SOFT_SPI_LOW); /* a slave shifts out output data bit */
		byte <<= 1;
		if (spi->get_miso())
			byte |= 0x01;

		spi->set_clk(SOFT_SPI_HIGH); /* a slave latches input data bit */
	}
	return(byte);
}

uint8_t SOFT_SPI_transfer_byte_CS_off(spi_device_t *spi, uint8_t byte)
{
	uint8_t retval = 0;

	soft_spi_t *psoft_spi = spi->spi_master->platform_drv_info;

	switch (spi->mode)
	{
	case MODE_0_0:
		retval = SOFT_SPI_transfer_mode_0_0(psoft_spi, byte);
		break;
	case MODE_1_1:
		retval = SOFT_SPI_transfer_mode_1_1(psoft_spi, byte);
		break;
	default:
		retval = SOFT_SPI_transfer_mode_0_0(psoft_spi, byte);
	}
	psoft_spi->set_mosi(SOFT_SPI_HIGH);
	return retval;
}

uint8_t SOFT_SPI_transfer_byte_CS_on(spi_device_t *spi, uint8_t byte)
{
	uint8_t retval = 0;
	soft_spi_t *psoft_spi = spi->spi_master->platform_drv_info;
	psoft_spi->set_cs(spi->pin, SOFT_SPI_LOW);
	retval = SOFT_SPI_transfer_byte_CS_off(spi, byte);
	psoft_spi->set_cs(spi->pin, SOFT_SPI_HIGH);
	return retval;
}

void SOFT_SPI_transfer_msg(spi_device_t *spi, uint8_t *data_out, uint8_t *data_in, uint16_t len)
{
	uint16_t i = 0;

	soft_spi_t *psoft_spi = spi->spi_master->platform_drv_info;
	psoft_spi->set_cs(spi->pin, SOFT_SPI_LOW);
	for(i=0;i<len;i++)
	{
		if(data_in != NULL)
			data_in[i] = SOFT_SPI_transfer_byte_CS_off(spi, data_out[i]);
		else
			SOFT_SPI_transfer_byte_CS_off(spi, data_out[i]);
	}
	psoft_spi->set_cs(spi->pin, SOFT_SPI_HIGH);
}

void SOFT_SPI_set_cs(spi_device_t *spi, uint8_t val)
{
	soft_spi_t *psoft_spi = spi->spi_master->platform_drv_info;
	if(val == SPI_COMMON_HIGH)
		psoft_spi->set_cs(spi->pin, SOFT_SPI_HIGH);
	else
		psoft_spi->set_cs(spi->pin, SOFT_SPI_LOW);
} 
