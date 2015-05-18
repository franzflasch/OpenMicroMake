PKG_NAME := test_project

PKG_DEPS := omm_common
PKG_DEPS += gpio_common
PKG_DEPS += mach_atmega8
PKG_DEPS += mach_avr_common
PKG_DEPS += cordic

PKG_URI := local
PKG_SRC := src/blinky.c
PKG_INC :=
PKG_BASEDIR := $(call get_basedir)

include scripts/OMM_package.mk

define Package/$(PKG_NAME)/Info
	$(info Package info:)
	$(info $(PKG_NAME))
	$(info $(PKG_SRC))
endef

#define Package/Download/$(PKG_NAME)
#	$(info Hey I am overriding the default download method!:)
#endef

#define Package/Build/$(PKG_NAME)
#	$(info overiding default $(PKG_NAME) build)
#endef

$(eval $(call Global/ProjectSetup,$(PKG_NAME),$(PKG_DEPS)))
$(eval $(call Package/Setup,$(PKG_NAME)))
