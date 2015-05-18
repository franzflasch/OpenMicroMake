PKG_NAME := omm_common

PKG_URI := local
PKG_SRC := src/OMM_machine_common.c
PKG_INC := inc
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

$(eval $(call Package/Setup,$(PKG_NAME)))
