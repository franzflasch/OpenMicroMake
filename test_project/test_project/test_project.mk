PKG_NAME := test_project

PKG_DEPS := omm_common
PKG_DEPS += gpio_common
PKG_DEPS += cordic

ifeq ($(MACH),stm32f1)
PKG_DEPS += mach_stm32f1
PKG_DEPS += mach_stm32_common
endif

ifeq ($(MACH),stm32f40x)
PKG_DEPS += mach_stm32f4
PKG_DEPS += mach_stm32_common
endif

ifeq ($(MACH),stm32f3)
PKG_DEPS += mach_stm32f3
PKG_DEPS += mach_stm32_common
endif

ifeq ($(MACH),atmega8)
PKG_DEPS += mach_atmega8
PKG_DEPS += mach_avr_common
endif

ifeq ($(MACH),atmega168)
PKG_DEPS += mach_atmega168
PKG_DEPS += mach_avr_common
endif

PKG_SRC := src/blinky.c

include scripts/OMM_package_rules.mk

$(eval $(call Package/Setup,$(PKG_NAME)))
