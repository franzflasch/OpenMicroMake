/*
 * i2c_common.h
 *
 *  Created on: Feb 14, 2015
 *      Author: franz
 */

#ifndef I2C_COMMON_H_
#define I2C_COMMON_H_

#include <stdint.h>

typedef struct i2c_device_s i2c_device_t;
typedef struct i2c_master_s i2c_master_t;

struct i2c_master_s
{
	uint8_t (*I2C_transmit_byte)(i2c_device_t *i2c, uint8_t byte);
	uint8_t (*I2C_receive_byte)(i2c_device_t *i2c);
	uint8_t (*I2C_send_msg_cmd)(i2c_device_t *i2c, uint8_t cmd, uint8_t *data, uint8_t count);
	uint8_t (*I2C_receive_msg_cmd)(i2c_device_t *i2c, uint8_t cmd, uint8_t *data, uint8_t count);
	void *platform_drv_info;
};

struct i2c_device_s
{
	uint8_t address;
	i2c_master_t *i2c_master;
};

void I2C_init_master(i2c_master_t *master,
					 void *i2c_trans_byte,
					 void *i2c_rec_byte,
					 void *i2c_send_msg_cmd,
					 void *i2c_receive_msg_cmd,
					 void *platform_drv_info);

void I2C_init_device(i2c_device_t *i2c_dev, uint8_t address, i2c_master_t *master);
void I2C_set_dev_address(i2c_device_t *i2c_dev, uint8_t address);

uint8_t I2C_transfer_byte(i2c_device_t *i2c, uint8_t val);
uint8_t I2C_receive_byte(i2c_device_t *i2c);
uint8_t I2C_send_msg_cmd(i2c_device_t *i2c, uint8_t cmd, uint8_t *data, uint8_t count);
uint8_t I2C_receive_msg_cmd(i2c_device_t *i2c, uint8_t cmd, uint8_t *data, uint8_t count);

#endif /* I2C_COMMON_H_ */
