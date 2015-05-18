PKG_NAME := mach_avr_common
PKG_DEPS :=
PKG_SRC := src/OMM_common_avr.c
PKG_BASEDIR := $(call get_basedir)
PKG_URI := local

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

$(eval $(call Package/Setup,$(PKG_NAME)))
