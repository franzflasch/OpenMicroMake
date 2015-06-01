/*
 * i2c_common.c
 *
 *  Created on: Feb 14, 2015
 *      Author: franz
 */

#include <i2c_common.h>

void I2C_init_master(i2c_master_t *master,
					 void *i2c_trans_byte,
					 void *i2c_rec_byte,
					 void *i2c_send_msg_cmd,
					 void *i2c_receive_msg_cmd,
					 void *platform_drv_info)
{
	master->I2C_transmit_byte = i2c_trans_byte;
	master->I2C_receive_byte = i2c_rec_byte;
	master->I2C_send_msg_cmd = i2c_send_msg_cmd;
	master->I2C_receive_msg_cmd = i2c_receive_msg_cmd;
	master->platform_drv_info = platform_drv_info;
}

void I2C_init_device(i2c_device_t *i2c_dev, uint8_t address, i2c_master_t *master)
{
	i2c_dev->address = address;
	i2c_dev->i2c_master = master;
}

void I2C_set_dev_address(i2c_device_t *i2c_dev, uint8_t address)
{
	i2c_dev->address = address;
}

uint8_t I2C_transfer_byte(i2c_device_t *i2c, uint8_t val)
{
	return i2c->i2c_master->I2C_transmit_byte(i2c, val);
}

uint8_t I2C_receive_byte(i2c_device_t *i2c)
{
	return i2c->i2c_master->I2C_receive_byte(i2c);
}

uint8_t I2C_send_msg_cmd(i2c_device_t *i2c, uint8_t cmd, uint8_t *data, uint8_t count)
{
	return i2c->i2c_master->I2C_send_msg_cmd(i2c, cmd, data, count);
}

uint8_t I2C_receive_msg_cmd(i2c_device_t *i2c, uint8_t cmd, uint8_t *data, uint8_t count)
{
	return i2c->i2c_master->I2C_receive_msg_cmd(i2c, cmd, data, count);
}
