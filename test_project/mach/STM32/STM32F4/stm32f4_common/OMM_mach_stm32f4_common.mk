PKG_NAME := mach_stm32f4_common

ifeq ($(MACH),stm32f40x)
PKG_SRC := src/OMM_common_stm32.c
PKG_DEPS := stm32f4lib
endif

ifeq ($(MACH),stm32f40x_opencm3)
PKG_SRC := src/OMM_common_stm32_opencm3.c
PKG_DEPS := libopencm3
endif

PKG_DEPS += omm_common

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

$(eval $(call Package/Setup,$(PKG_NAME)))
