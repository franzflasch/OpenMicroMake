PKG_NAME := mach_stm32f1

ifeq ($(UCLIB),st_library)
PKG_DEPS := stm32f1lib
PKG_SRC := src/OMM_mach_stm32f1.c
endif

ifeq ($(UCLIB),libopencm3)
PKG_DEPS := libopencm3
PKG_SRC := src/OMM_mach_stm32f1_opencm3.c
endif

PKG_DEPS += omm_common
PKG_DEPS += gpio_common

include scripts/OMM_package_rules.mk

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

$(eval $(call Package/Setup,$(PKG_NAME)))
