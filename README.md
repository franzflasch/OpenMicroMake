# OpenMicroMake
Buildsystem for Microcontrollers.

# Prerequisites
- Microcontroller toolchain (arm-none-eabi, avr, ...)
- make
- unzip
- quilt

# Getting Started
You can build the test_project with (from within the base directory):

make PROJECT=test_project/test_project.conf test_project/hex

or if you want to generate a binary file (e.g. for stm32)

make PROJECT=test_project/test_project.conf test_project/bin

# Configuring own Projects
It is easy to setup own projects:
Just take a look at the test_project.conf and test_project.mk files to get an idea how to setup your own
project. In the .conf file there are some definitions of the used microcontroller and architecture. The .mk file
defines the dependencies and sources of your own project.

# Supported Microcontrollers
The OpenMicroMake buildframework can basically used for every microcontroller. 
However the test_project only supports the stm32f4discovery, the olimex stm32h103, the atmega8 and the atmega168.

# Just to mention...
This project uses external libraries such as libopencm3, st standard peripheral library, etc. for building.