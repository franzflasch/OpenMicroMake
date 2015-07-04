#include <nrf24xx.h>
#ifdef __KERNEL__
#include <linux/types.h>
#include <linux/string.h>
#else
#include <stdio.h>
#include <string.h>
#endif

/* Memory Map */
#define NRF24_CONFIG      0x00
#define NRF24_EN_AA       0x01
#define NRF24_EN_RXADDR   0x02
#define NRF24_SETUP_AW    0x03
#define NRF24_SETUP_RETR  0x04
#define NRF24_RF_CH       0x05
#define NRF24_RF_SETUP    0x06
#define NRF24_STATUS      0x07
#define NRF24_OBSERVE_TX  0x08
#define NRF24_CD          0x09
#define NRF24_RX_ADDR_P0  0x0A
#define NRF24_RX_ADDR_P1  0x0B
#define NRF24_RX_ADDR_P2  0x0C
#define NRF24_RX_ADDR_P3  0x0D
#define NRF24_RX_ADDR_P4  0x0E
#define NRF24_RX_ADDR_P5  0x0F
#define NRF24_TX_ADDR     0x10
#define NRF24_RX_PW_P0    0x11
#define NRF24_RX_PW_P1    0x12
#define NRF24_RX_PW_P2    0x13
#define NRF24_RX_PW_P3    0x14
#define NRF24_RX_PW_P4    0x15
#define NRF24_RX_PW_P5    0x16
#define NRF24_FIFO_STATUS 0x17
#define NRF24_DYNPD       0x1C

/* Bit Mnemonics */

/* configuratio nregister */
#define NRF24_MASK_RX_DR  6
#define NRF24_MASK_TX_DS  5
#define NRF24_MASK_MAX_RT 4
#define NRF24_EN_CRC      3
#define NRF24_CRCO        2
#define NRF24_PWR_UP      1
#define NRF24_PRIM_RX     0

/* enable auto acknowledgment */
#define NRF24_ENAA_P5     5
#define NRF24_ENAA_P4     4
#define NRF24_ENAA_P3     3
#define NRF24_ENAA_P2     2
#define NRF24_ENAA_P1     1
#define NRF24_ENAA_P0     0

/* enable rx addresses */
#define NRF24_ERX_P5      5
#define NRF24_ERX_P4      4
#define NRF24_ERX_P3      3
#define NRF24_ERX_P2      2
#define NRF24_ERX_P1      1
#define NRF24_ERX_P0      0

/* setup of address width */
#define NRF24_AW          0 /* 2 bits */

/* setup of auto re-transmission */
#define NRF24_ARD         4 /* 4 bits */
#define NRF24_ARC         0 /* 4 bits */

/* RF setup register */
#define NRF24_PLL_LOCK    4
#define NRF24_RF_DR       3
#define NRF24_RF_PWR      1 /* 2 bits */

/* general status register */
#define NRF24_RX_DR       6
#define NRF24_TX_DS       5
#define NRF24_MAX_RT      4
#define NRF24_RX_P_NO     1 /* 3 bits */
#define NRF24_TX_FULL     0

/* transmit observe register */
#define NRF24_PLOS_CNT    4 /* 4 bits */
#define NRF24_ARC_CNT     0 /* 4 bits */

/* fifo status */
#define NRF24_TX_REUSE    6
#define NRF24_FIFO_FULL   5
#define NRF24_TX_EMPTY    4
#define NRF24_RX_FULL     1
#define NRF24_RX_EMPTY    0

/* dynamic length */
#define NRF24_DPL_P0      0
#define NRF24_DPL_P1      1
#define NRF24_DPL_P2      2
#define NRF24_DPL_P3      3
#define NRF24_DPL_P4      4
#define NRF24_DPL_P5      5

/* Instruction Mnemonics */
#define NRF24_R_REGISTER    0x00 /* last 4 bits will indicate reg. address */
#define NRF24_W_REGISTER    0x20 /* last 4 bits will indicate reg. address */
#define NRF24_REGISTER_MASK 0x1F
#define NRF24_R_RX_PAYLOAD  0x61
#define NRF24_W_TX_PAYLOAD  0xA0
#define NRF24_FLUSH_TX      0xE1
#define NRF24_FLUSH_RX      0xE2
#define NRF24_REUSE_TX_PL   0xE3
#define NRF24_ACTIVATE      0x50
#define NRF24_R_RX_PL_WID   0x60
#define NRF24_NOP           0xFF

#define NRF24_LOW 0
#define NRF24_HIGH 1

#define nrf24_ADDR_LEN 5
#define nrf24_CONFIG ((1<<NRF24_EN_CRC)|(0<<NRF24_CRCO))

/* PRIVATE */
static uint8_t nrf24xx_transfer(nrf24xx_t *nrf24, uint8_t val)
{
   return nrf24->SPI_transfer_byte(nrf24->spi, val);
}

/* send and receive multiple bytes over SPI */
static void nrf24_transferSync(nrf24xx_t *nrf24, uint8_t* dataout, uint8_t* datain, uint8_t len)
{
    nrf24->SPI_transfer_msg(nrf24->spi, dataout, datain, len);
}

/* Clocks only one byte into the given nrf24 register */
static void nrf24_configRegister(nrf24xx_t *nrf24, uint8_t reg, uint8_t value)
{
	nrf24->spi_msg[0] = (NRF24_W_REGISTER | (NRF24_REGISTER_MASK & reg));
	nrf24->spi_msg[1] = value;
	nrf24_transferSync(nrf24, nrf24->spi_msg, NULL, 2);
}

/* Read single register from nrf24 */
static void nrf24_readRegister(nrf24xx_t *nrf24, uint8_t reg, uint8_t *value, uint8_t len)
{
	nrf24->spi_msg[0] = (NRF24_R_REGISTER | (NRF24_REGISTER_MASK & reg));
	nrf24_transferSync(nrf24, nrf24->spi_msg, nrf24->spi_msg, len+1);
	memcpy(value, &nrf24->spi_msg[1], len);
}

/* Write to a single register of nrf24 */
static void nrf24_writeRegister(nrf24xx_t *nrf24, uint8_t reg, uint8_t *value, uint8_t len)
{
	nrf24->spi_msg[0] = (NRF24_W_REGISTER | (NRF24_REGISTER_MASK & reg));

	/* copy the message to the spi msg buffer */
	memcpy(&nrf24->spi_msg[1], value, len);
	nrf24_transferSync(nrf24, nrf24->spi_msg, NULL, len+1);
}




/* PUBLIC */
void nrf24_init(nrf24xx_t *nrf24,
				void *nrf24_spi,
				void *spi_transfer_byte,
				void *spi_transfer_msg,
				void *nrf24xx_set_ce,
				void *nrf24_delay_func)
{
    nrf24->spi = nrf24_spi;
    nrf24->SPI_transfer_byte = spi_transfer_byte;
    nrf24->SPI_transfer_msg = spi_transfer_msg;

    nrf24->NRF24XX_set_ce = nrf24xx_set_ce;
    nrf24->NRF24XX_set_ce(NRF24_LOW);

    nrf24->NRF24XX_delay_func = nrf24_delay_func;
}

/* configure the module */
void nrf24_config(nrf24xx_t *nrf24, uint8_t channel, uint8_t pay_length)
{
    /* Use static payload length ... */
    nrf24->payload_len = pay_length;

    // Set RF channel
    nrf24_configRegister(nrf24, NRF24_RF_CH, channel);

    // Set length of incoming payload 
    nrf24_configRegister(nrf24, NRF24_RX_PW_P0, 0x00); // Auto-ACK pipe ...
    nrf24_configRegister(nrf24, NRF24_RX_PW_P1, pay_length); // Data payload pipe
    nrf24_configRegister(nrf24, NRF24_RX_PW_P2, 0x00); // Pipe not used 
    nrf24_configRegister(nrf24, NRF24_RX_PW_P3, 0x00); // Pipe not used 
    nrf24_configRegister(nrf24, NRF24_RX_PW_P4, 0x00); // Pipe not used 
    nrf24_configRegister(nrf24, NRF24_RX_PW_P5, 0x00); // Pipe not used 

    // 1 Mbps, TX gain: 0dbm
    nrf24_configRegister(nrf24, NRF24_RF_SETUP, (0<<NRF24_RF_DR)|((0x03)<<NRF24_RF_PWR));

    // CRC enable, 1 byte CRC length
    nrf24_configRegister(nrf24, NRF24_CONFIG,nrf24_CONFIG);

    // Auto Acknowledgment
    nrf24_configRegister(nrf24, NRF24_EN_AA,(1<<NRF24_ENAA_P0)|(1<<NRF24_ENAA_P1)|(0<<NRF24_ENAA_P2)|(0<<NRF24_ENAA_P3)|(0<<NRF24_ENAA_P4)|(0<<NRF24_ENAA_P5));

    // Enable RX addresses
    nrf24_configRegister(nrf24, NRF24_EN_RXADDR,(1<<NRF24_ERX_P0)|(1<<NRF24_ERX_P1)|(0<<NRF24_ERX_P2)|(0<<NRF24_ERX_P3)|(0<<NRF24_ERX_P4)|(0<<NRF24_ERX_P5));

    // Auto retransmit delay: 1000 us and Up to 15 retransmit trials
    nrf24_configRegister(nrf24, NRF24_SETUP_RETR,(0x04<<NRF24_ARD)|(0x0F<<NRF24_ARC));

    // Dynamic length configurations: No dynamic length
    nrf24_configRegister(nrf24, NRF24_DYNPD,(0<<NRF24_DPL_P0)|(0<<NRF24_DPL_P1)|(0<<NRF24_DPL_P2)|(0<<NRF24_DPL_P3)|(0<<NRF24_DPL_P4)|(0<<NRF24_DPL_P5));

    // Start listening
    nrf24_powerUpRx(nrf24);
}

void nrf24_powerUpRx(nrf24xx_t *nrf24)
{
   nrf24xx_transfer(nrf24, NRF24_FLUSH_RX);
   nrf24_configRegister(nrf24, NRF24_STATUS,(1<<NRF24_RX_DR)|(1<<NRF24_TX_DS)|(1<<NRF24_MAX_RT));

   nrf24->NRF24XX_set_ce(NRF24_LOW);
   nrf24_configRegister(nrf24, NRF24_CONFIG,nrf24_CONFIG|((1<<NRF24_PWR_UP)|(1<<NRF24_PRIM_RX)));
   nrf24->NRF24XX_set_ce(NRF24_HIGH);
}

void nrf24_powerUpTx(nrf24xx_t *nrf24)
{
    nrf24_configRegister(nrf24, NRF24_STATUS,(1<<NRF24_RX_DR)|(1<<NRF24_TX_DS)|(1<<NRF24_MAX_RT));
    nrf24_configRegister(nrf24, NRF24_CONFIG,nrf24_CONFIG|((1<<NRF24_PWR_UP)|(0<<NRF24_PRIM_RX)));
}

void nrf24_powerDown(nrf24xx_t *nrf24)
{
    nrf24->NRF24XX_set_ce(NRF24_LOW);
    nrf24_configRegister(nrf24, NRF24_CONFIG,nrf24_CONFIG);
}

/* Set the RX address */
void nrf24_rx_address(nrf24xx_t *nrf24, uint8_t * adr) 
{
    nrf24->NRF24XX_set_ce(NRF24_LOW);
    nrf24_writeRegister(nrf24, NRF24_RX_ADDR_P1,adr,nrf24_ADDR_LEN);
    nrf24->NRF24XX_set_ce(NRF24_HIGH);
}

/* Set the TX address */
void nrf24_tx_address(nrf24xx_t *nrf24, uint8_t* adr)
{
    /* RX_ADDR_P0 must be set to the sending addr for auto ack to work. */
    nrf24_writeRegister(nrf24, NRF24_RX_ADDR_P0,adr,nrf24_ADDR_LEN);
    nrf24_writeRegister(nrf24, NRF24_TX_ADDR,adr,nrf24_ADDR_LEN);
}

/* Checks if data is available for reading */
/* Returns 1 if data is ready ... */
uint8_t nrf24_dataReady(nrf24xx_t *nrf24) 
{
    // See note in getData() function - just checking RX_DR isn't good enough
    uint8_t status = nrf24_getStatus(nrf24);

    // We can short circuit on RX_DR, but if it's not set, we still need
    // to check the FIFO for any pending packets
    if ( status & (1 << NRF24_RX_DR) ) 
    {
        return 1;
    }

    return !nrf24_rxFifoEmpty(nrf24);
}

/* Checks if receive FIFO is empty or not */
uint8_t nrf24_rxFifoEmpty(nrf24xx_t *nrf24)
{
    uint8_t fifoStatus;

    nrf24_readRegister(nrf24, NRF24_FIFO_STATUS, &fifoStatus, 1);
    
    return (fifoStatus & (1 << NRF24_RX_EMPTY));
}

/* Returns the length of data waiting in the RX fifo */
uint8_t nrf24_payloadLength(nrf24xx_t *nrf24)
{
	nrf24->spi_msg[0] = NRF24_R_RX_PL_WID;
	nrf24->spi_msg[1] = 0x00;

	nrf24_transferSync(nrf24, nrf24->spi_msg, nrf24->spi_msg, 2);

	/* Hopefully contains the status */
	return nrf24->spi_msg[1];
}

/* Reads payload bytes into data array */
void nrf24_getData(nrf24xx_t *nrf24, uint8_t* data) 
{
	nrf24->spi_msg[0] = NRF24_R_RX_PAYLOAD;
	memset(&nrf24->spi_msg[1], 0, nrf24->payload_len);
	nrf24_transferSync(nrf24, nrf24->spi_msg, nrf24->spi_msg, nrf24->payload_len+1);

	memcpy(data, &nrf24->spi_msg[1], nrf24->payload_len);

	/* Reset status register */
	nrf24_configRegister(nrf24, NRF24_STATUS,(1<<NRF24_RX_DR));
}

/* Returns the number of retransmissions occured for the last message */
uint8_t nrf24_retransmissionCount(nrf24xx_t *nrf24)
{
    uint8_t rv;
    nrf24_readRegister(nrf24, NRF24_OBSERVE_TX,&rv,1);
    rv = rv & 0x0F;
    return rv;
}

// Sends a data package to the default address. Be sure to send the correct
// amount of bytes as configured as payload on the receiver.
void nrf24_send(nrf24xx_t *nrf24, uint8_t* value) 
{    
    /* Go to Standby-I first */
    nrf24->NRF24XX_set_ce(NRF24_LOW);
     
    /* Set to transmitter mode , Power up if needed */
    nrf24_powerUpTx(nrf24);

    /* Do we really need to flush TX fifo each time ? */
    #if 1
        /* Write cmd to flush transmit FIFO */
        nrf24xx_transfer(nrf24, NRF24_FLUSH_TX);
    #endif

	nrf24->spi_msg[0] = NRF24_W_TX_PAYLOAD;

	/* copy the message to the spi msg buffer */
	memcpy(&nrf24->spi_msg[1], value, nrf24->payload_len);
	nrf24_transferSync(nrf24, nrf24->spi_msg, NULL, nrf24->payload_len+1);

    /* Start the transmission */
    nrf24->NRF24XX_set_ce(NRF24_HIGH);
}

uint8_t nrf24_isSending(nrf24xx_t *nrf24)
{
    uint8_t status;

    /* read the current status */
    status = nrf24_getStatus(nrf24);
                
    /* if sending successful (TX_DS) or max retries exceded (MAX_RT). */
    if((status & ((1 << NRF24_TX_DS)  | (1 << NRF24_MAX_RT))))
    {        
        return 0; /* false */
    }

    return 1; /* true */

}

uint8_t nrf24_getStatus(nrf24xx_t *nrf24)
{
    uint8_t rv;
    rv = nrf24xx_transfer(nrf24, NRF24_NOP);
    return rv;
}

uint8_t nrf24_lastMessageStatus(nrf24xx_t *nrf24)
{
    uint8_t rv;

    rv = nrf24_getStatus(nrf24);

    /* Transmission went OK */
    if((rv & ((1 << NRF24_TX_DS))))
    {
        return NRF24_TRANSMISSON_OK;
    }
    /* Maximum retransmission count is reached */
    /* Last message probably went missing ... */
    else if((rv & ((1 << NRF24_MAX_RT))))
    {
        return NRF24_MESSAGE_LOST;
    }  
    /* Probably still sending ... */
    else
    {
        return 0xFF;
    }
}


/****** HIGH LEVEL API ******/

static int8_t nrf24xx_send_wait(nrf24xx_t *nrf24, uint8_t *message)
{
	uint8_t temp;

	/* Automatically goes to TX mode */
	nrf24_send(nrf24, message);

	/* Wait for transmission to end */
	while(nrf24_isSending(nrf24))
	{
		printf("Waiting for sending...\n\r");
		nrf24->NRF24XX_delay_func(NRF24_USED_RX_TX_DELAY);
	}

	/* Make analysis on last tranmission attempt */
	temp = nrf24_lastMessageStatus(nrf24);
	if(temp == NRF24_TRANSMISSON_OK)
	{
		printf("> Tranmission went OK\r\n");
		return NRF_RETURN_STATUS_OK;
	}
	else if(temp == NRF24_MESSAGE_LOST)
	{
		printf("> Message is lost ...\r\n");
	}

	return NRF_RETURN_STATUS_ERROR;
}

static int8_t nrf24xx_receive_msg(nrf24xx_t *nrf24, uint8_t *message, uint16_t len, uint8_t dont_block)
{
	uint8_t i = 0;
	uint8_t j = 0;

	nrf24_powerUpRx(nrf24);

	/* Payload message */
	for(i=0;i<NRF24_MAX_FAILED_COUNTER;i++)
	{
		if(nrf24_dataReady(nrf24))
		{
			nrf24_getData(nrf24, message);
			printf("> ");
			for(j=0;j<len;j++)
			{
				printf("%2X ",message[j]);
			}
			printf("\r\n");
			break;
		}

		/* Return here if dont_block is set, do not wait too long,
		 * this allows slaves to do something
		 * else in the meantime */
		if(dont_block && i > 5)
		{
			return NRF_RETURN_STATUS_NO_DATA;
		}

		nrf24->NRF24XX_delay_func(NRF24_USED_RX_TX_DELAY/2);
	}

	if(i == NRF24_MAX_FAILED_COUNTER)
	{
		printf("More than %d cycles no data returning here...\n\r", NRF24_MAX_FAILED_COUNTER);
		return NRF_RETURN_STATUS_ERROR;
	}

	return NRF_RETURN_STATUS_OK;
}

int8_t NRF24XX_master_send_message(nrf24xx_t *nrf24, uint8_t channel, uint8_t* own_addr, uint8_t* tx_addr, uint8_t *msg, uint16_t len)
{
	uint8_t i = 0;
	uint8_t temp = 0;
	uint8_t init_message[NRF24_MESSAGE_LEN];

	/* Zero the init message */
	memset(init_message, 0, sizeof(init_message));

	/* Sanity checks */
	if(len > NRF24_MESSAGE_LEN)
	{
		return NRF_RETURN_STATUS_ERROR;
	}

	/* Fill the data buffer */
	init_message[0] = NRF24_WRITE_REQ;
	init_message[1] = ((len & 0xFF00)>>8);
	init_message[2] = (len & 0x00FF);
	init_message[3] = 0; /* MSG TYPE */
	init_message[4] = 0; /* Register Address */
	init_message[5] = 0; /* Register Address */
	init_message[6] = 0; /* Register Address */
	init_message[7] = 0; /* Register Address */

	nrf24_config(nrf24, NRF24_DEFAULT_CHANNEL, NRF24_MESSAGE_LEN);
	nrf24_tx_address(nrf24, tx_addr);
	nrf24_rx_address(nrf24, own_addr);

	temp = nrf24xx_send_wait(nrf24, init_message);
	if(temp != NRF_RETURN_STATUS_OK)
	{
		return temp;
	}

	/* wait some time to ensure the slave is already in reception mode */
	nrf24->NRF24XX_delay_func(NRF24_USED_RX_TX_DELAY);

	for(i=0;i<NRF24_NR_TX_MESSAGES;i++)
	{
		nrf24->NRF24XX_delay_func(NRF24_USED_RX_TX_DELAY);
		temp =  nrf24xx_send_wait(nrf24, msg);
		if(temp != NRF_RETURN_STATUS_OK)
		{
			printf("ERR send\r\n");
		}
	}
	nrf24_powerDown(nrf24);
	return temp;
}

int8_t NRF24XX_master_receive_message(nrf24xx_t *nrf24, uint8_t channel, uint8_t* own_addr, uint8_t* tx_addr, uint8_t *msg, uint16_t len)
{
	uint8_t retry = 0;
	uint8_t temp = 0;
	uint8_t message[NRF24_MESSAGE_LEN];

	/* Zero the init message */
	memset(message, 0, sizeof(message));

	/* Sanity checks */
	if(len > NRF24_SPI_MSG_MAX_LEN)
	{
		return NRF_RETURN_STATUS_ERROR;
	}

	/* Very ugly but I do not see any other solution - sometimes this stupid chip just
	 * doesn't work - so if this function fails it will be tried a second time
	 *
	 *  */
	RETRY:

	/* Fill the data buffer */
	message[0] = NRF24_READ_REQ;
	message[1] = ((len & 0xFF00)>>8);
	message[2] = (len & 0x00FF);
	message[3] = 0; /* MSG TYPE */
	message[4] = 0; /* Register Address */
	message[5] = 0; /* Register Address */
	message[6] = 0; /* Register Address */
	message[7] = 0; /* Register Address */

	nrf24_config(nrf24, channel, NRF24_MESSAGE_LEN);
	nrf24_tx_address(nrf24, tx_addr);
	nrf24_rx_address(nrf24, own_addr);

	temp = nrf24xx_send_wait(nrf24, message);
	if(temp != NRF_RETURN_STATUS_OK)
	{
		printf("ERR send_wait\r\n");
		return temp;
	}

	temp = nrf24xx_receive_msg(nrf24, message, NRF24_MESSAGE_LEN, 0);
	if(temp != NRF_RETURN_STATUS_OK)
	{
		printf("ERR receive\r\n");
		if(retry == 0)
		{
			retry = 1;
			goto RETRY;
		}
	}

	nrf24_powerDown(nrf24);
	return temp;
}

int8_t NRF24XX_slave_handler(nrf24xx_t *nrf24, uint8_t channel, uint8_t* own_addr, uint8_t *tx_addr)
{
	int8_t i = 0;
	int8_t temp = 0;
	uint8_t message[NRF24_MESSAGE_LEN];

	uint8_t read_write_req = 0;
	uint16_t rec_msg_len = 0;

//	nrf24_config(nrf24, channel, NRF24_MESSAGE_LEN);
//	nrf24_tx_address(nrf24, tx_addr);
//	nrf24_rx_address(nrf24, own_addr);

	/* Zero the init message */
	memset(message, 0, sizeof(message));
	temp = nrf24xx_receive_msg(nrf24, message, NRF24_MESSAGE_LEN, 1);
	if(temp != NRF_RETURN_STATUS_OK)
	{
		return temp;
	}

	read_write_req = message[0];

	/* Get message len */
	rec_msg_len = ((message[1] << 8) | message[2]);
	printf("MSG len: %d\r\n", rec_msg_len);

	if(rec_msg_len > NRF24_MESSAGE_LEN)
	{
		printf("ERR: Message len: %d\r\n");
		return NRF_RETURN_STATUS_ERROR;
	}

	/* Get message read/write request */
	if(read_write_req == NRF24_READ_REQ)
	{
		printf("RD Req\r\n");
		for(i=0;i<rec_msg_len;i++)
		{
			message[i] = i;
		}

		/* Wait some time to ensure the master is already in receive mode */
		nrf24->NRF24XX_delay_func(NRF24_USED_RX_TX_DELAY);
		temp = nrf24xx_send_wait(nrf24, message);
	}
	else
	{
		for(i=0;i<NRF24_NR_TX_MESSAGES;i++)
		{
			temp = nrf24xx_receive_msg(nrf24, message, rec_msg_len, 0);
			if(temp != NRF_RETURN_STATUS_OK)
			{
				printf("ERR receive\r\n");
			}
		}
	}

	nrf24_powerDown(nrf24);
	return temp;
}
