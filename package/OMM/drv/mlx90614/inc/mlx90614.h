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

#ifndef MLX90614_H
#define MLX90614_H

#include <stdint.h>

typedef struct mlx90614_s
{
   /* i2c interface */
   void *i2c;

   /* Function pointers to the corresponding SPI driver layer */
   uint8_t (*I2C_transmit_msg_cmd)(void *i2c, uint8_t cmd, uint8_t *data_out, uint8_t count);
   uint8_t (*I2C_receive_msg_cmd)(void *i2c, uint8_t cmd, uint8_t *data_in, uint8_t count);
   uint8_t (*I2C_set_dev_address)(void *i2c, uint8_t address);

   /* Hardware specific */
   void (*MLX90614_enable_i2c)(void);

}mlx90614_t;

void mlx90614_init(mlx90614_t *mlx_dev, void *i2c_iface, void *i2c_transmit, void *i2c_receive, void *i2c_set_dev_addr, void *mlx_i2c_enable);
float mlx90614_get_temp_celcius(mlx90614_t *mlx_dev, uint8_t ambient);

#endif
