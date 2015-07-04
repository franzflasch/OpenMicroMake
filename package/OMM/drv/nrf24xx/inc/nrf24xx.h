/*
    Copyright (c) 2007 Stefan Engelke <mbox@stefanengelke.de>

    Permission is hereby granted, free of charge, to any person 
    obtaining a copy of this software and associated documentation 
    files (the "Software"), to deal in the Software without 
    restriction, including without limitation the rights to use, copy, 
    modify, merge, publish, distribute, sublicense, and/or sell copies 
    of the Software, and to permit persons to whom the Software is 
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be 
    included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
    HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
    DEALINGS IN THE SOFTWARE.

    $Id$
*/

#ifndef NRF24XX_H
#define NRF24XX_H

#ifdef __KERNEL__
#include <linux/types.h>
#else
#include <stdint.h>
#endif

/* Settings */
#define NRF24_MESSAGE_LEN 16
#define NRF24_DEFAULT_CHANNEL 2
/* NOTE: this should be an even number - otherwise the nrf24l01 or this software doesn't work properly ;)*/
#define NRF24_NR_TX_MESSAGES 1
#define NRF24_USED_RX_TX_DELAY 100

#define NRF24_READ_REQ 0
#define NRF24_WRITE_REQ 1

#define NRF_RETURN_STATUS_OK 0
#define NRF_RETURN_STATUS_ERROR 1
#define NRF_RETURN_STATUS_NO_DATA 2

#define NRF24_MAX_FAILED_COUNTER 15

/* LOWLEVEL */
#define NRF24_TRANSMISSON_OK 0
#define NRF24_MESSAGE_LOST   1
#define NRF24_SPI_MSG_MAX_LEN 32

typedef struct nrf24xx_s
{
   /* spi interface */
   void *spi;

   /* Storage to build the SPI message maxlen is 32 + Control byte = 33 */
   uint8_t spi_msg[NRF24_SPI_MSG_MAX_LEN+1];

   /* Function pointers to the corresponding SPI driver layer */
   uint8_t (*SPI_transfer_byte)(void *spi, uint8_t val);
   void (*SPI_transfer_msg)(void *spi, uint8_t *data_out, uint8_t *data_in, uint16_t len);

   /* Hardware specific */
   void (*NRF24XX_set_ce)(uint8_t val);

   /* Software layer specific */
   void (*NRF24XX_delay_func)(uint64_t val);

   /* execution time infos */
   uint8_t payload_len;
   uint8_t channel;

}nrf24xx_t;

void nrf24_init(nrf24xx_t *nrf24,
				void *nrf24_spi,
				void *spi_transfer_byte,
				void *spi_transfer_msg,
				void *nrf24xx_set_ce,
				void *nrf24_delay_func);
void nrf24_config(nrf24xx_t *nrf24, uint8_t channel, uint8_t pay_length);
void nrf24_powerUpRx(nrf24xx_t *nrf24);
void nrf24_powerUpTx(nrf24xx_t *nrf24);
void nrf24_powerDown(nrf24xx_t *nrf24);
void nrf24_rx_address(nrf24xx_t *nrf24, uint8_t * adr);
void nrf24_tx_address(nrf24xx_t *nrf24, uint8_t* adr);
uint8_t nrf24_dataReady(nrf24xx_t *nrf24);
uint8_t nrf24_rxFifoEmpty(nrf24xx_t *nrf24);
uint8_t nrf24_payloadLength(nrf24xx_t *nrf24);
void nrf24_getData(nrf24xx_t *nrf24, uint8_t* data);
uint8_t nrf24_retransmissionCount(nrf24xx_t *nrf24);
void nrf24_send(nrf24xx_t *nrf24, uint8_t* value);
uint8_t nrf24_isSending(nrf24xx_t *nrf24);
uint8_t nrf24_getStatus(nrf24xx_t *nrf24);
uint8_t nrf24_lastMessageStatus(nrf24xx_t *nrf24);

int8_t NRF24XX_master_send_message(nrf24xx_t *nrf24, uint8_t channel, uint8_t* own_addr, uint8_t* tx_addr, uint8_t *msg, uint16_t len);
int8_t NRF24XX_master_receive_message(nrf24xx_t *nrf24, uint8_t channel, uint8_t* own_addr, uint8_t* tx_addr, uint8_t *msg, uint16_t len);
int8_t NRF24XX_slave_handler(nrf24xx_t *nrf24, uint8_t channel, uint8_t* own_addr, uint8_t *tx_addr);

#endif
