#include <mlx90614.h>
#include <stdio.h>
#include <string.h>

void mlx90614_init(mlx90614_t *mlx_dev, void *i2c_iface, void *i2c_transmit, void *i2c_receive, void *i2c_set_dev_addr, void *mlx_i2c_enable)
{
	mlx_dev->i2c = i2c_iface;
	mlx_dev->I2C_transmit_msg_cmd = i2c_transmit;
	mlx_dev->I2C_receive_msg_cmd = i2c_receive;
	mlx_dev->I2C_set_dev_address = i2c_set_dev_addr;
	mlx_dev->MLX90614_enable_i2c = mlx_i2c_enable;

	/* Enable the i2c bus */
	mlx_dev->MLX90614_enable_i2c();
}

void mlx90614_change_address(mlx90614_t *mlx_dev, uint8_t new_address)
{
	int a = 0;
	uint8_t data_to_send[] = {0x00, 0x00, 0x6F};

	/* Erase current address */
	mlx_dev->I2C_transmit_msg_cmd(mlx_dev->i2c, 0x2E, data_to_send, 3);

	/* OK set current temporary i2c_dev address */
	mlx_dev->I2C_set_dev_address(mlx_dev->i2c, 0x00);

	data_to_send[0] = new_address;

	printf("Trying to change i2c address..\n");

	for (a = 0; a <= 256; a++) {

		printf("Trying %d\n", a);

		data_to_send[2] = a;

		/* Now write the new address */
		if(mlx_dev->I2C_transmit_msg_cmd(mlx_dev->i2c, 0x2E, data_to_send, 3)==0)
		{
			/* OK everything is hopefully fine update the device to the new address */
			mlx_dev->I2C_set_dev_address(mlx_dev->i2c, new_address);
			return;
		}

		OMM_busy_delay(100);

	}

	printf("Correct CRC not found\n");
}

float mlx90614_get_temp_celcius(mlx90614_t *mlx_dev, uint8_t ambient)
{
	uint8_t rec_data[3];
	int data_low = 0;
	int data_high = 0;

	if(ambient)
	{
		mlx_dev->I2C_receive_msg_cmd(mlx_dev->i2c, 0x06, rec_data, 3);
	}
	else
	{
		mlx_dev->I2C_receive_msg_cmd(mlx_dev->i2c, 0x07, rec_data, 3);
	}

	data_low = rec_data[0];
	data_high = rec_data[1];

	// This converts high and low bytes together and processes temperature,
	// MSB is a error bit and is ignored for temps.
	double tempFactor = 0.02;       // 0.02 degrees per LSB (measurement
								  // resolution of the MLX90614).
	double tempData = 0x0000;       // Zero out the data

	// This masks off the error bit of the high byte, then moves it left
	// 8 bits and adds the low byte.
	tempData = (double)(((data_high & 0x007F) << 8) + data_low);
	tempData = (tempData * tempFactor)-0.01;
	float celcius = tempData - 273.15;

	// Returns temperature un Celcius.
	return celcius;
}



