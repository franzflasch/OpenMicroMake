/*
 * test_wrapper.cpp
 *
 *  Created on: Jun 29, 2015
 *      Author: fflasch
 */

#include <test_wrapper.h>
#include <test.h>
#include <stdio.h>

void test_wrapper(void)
{
	test_class test;

	test.test_func();

	printf("dsa\n\r");
}


