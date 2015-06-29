# Put here all necessary informations needed to build this package
PKG_NAME := test_lib_cpp
PKG_SRC := src/test.cpp
PKG_SRC += src/test_wrapper.cpp
PKG_INC := inc/

# Very important to include this after all PKG_ vars are set. This will setup specific package rules which
# will be called when building.
include scripts/OMM_package_rules.mk

# It is possible to overide the default build functions here - this is probably not really needed.

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

# store the package information globally - this is very important - it is needed for switching the package infos 
$(eval $(call Package/Setup,$(PKG_NAME)))
