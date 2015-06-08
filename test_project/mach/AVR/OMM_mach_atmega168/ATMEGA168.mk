PKG_NAME := mach_atmega168
PKG_SRC := src/OMM_mach_atmega168.c

include scripts/OMM_package_rules.mk

#define Package/Info/$(PKG_NAME)
#	$(info Package info:)
#	$(info $(PKG_NAME))
#	$(info $(global_inc_paths))
#endef

#define Package/Download/$(PKG_NAME)
#	$(info Hey I am overriding the default download method!:)
#endef

#define Package/Build/$(PKG_NAME)
#	$(info overiding default $(PKG_NAME) build)
#endef

$(eval $(call Package/Setup,$(PKG_NAME)))
