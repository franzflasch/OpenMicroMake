PKG_NAME := test_project

PKG_DEPS := omm_common
PKG_DEPS += gpio_common
PKG_DEPS += cordic

ifeq ($(MACH),stm32f40x)
PKG_DEPS += mach_stm32f4
PKG_DEPS += mach_stm32f4_common
endif

ifeq ($(MACH),atmega8)
PKG_DEPS += mach_atmega8
PKG_DEPS += mach_avr_common
endif

ifeq ($(MACH),atmega168)
PKG_GLOBAL_DEFS = "F_CPU=8000000"
PKG_DEPS += mach_atmega168
PKG_DEPS += mach_avr_common
endif

#PKG_DEPS += mach_stm32f1
#PKG_DEPS += mach_stm32f1_common

PKG_SRC := src/blinky.c

include scripts/OMM_package.mk

#define Package/$(PKG_NAME)/Info
#	$(info Package info:)
#	$(info $(PKG_NAME))
#	$(info $(PKG_SRC))
#endef

#define Package/Download/$(PKG_NAME)
#	$(info Hey I am overriding the default download method!:)
#endef

#define Package/Build/$(PKG_NAME)
#	$(info overiding default $(PKG_NAME) build)
#endef

#$(eval $(call Global/ProjectSetup,$(PKG_NAME),$(PKG_DEPS)))
$(eval $(call Package/Setup,$(PKG_NAME)))
