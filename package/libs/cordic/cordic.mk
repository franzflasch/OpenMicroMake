# Put here all necessary informations needed to build this package
PKG_NAME := cordic
PKG_URI := https://github.com/the0b/MSP430-CORDIC-sine-cosine/archive/master.zip
PKG_SRC := MSP430-CORDIC-sine-cosine-master/cordic.c
PKG_INC := MSP430-CORDIC-sine-cosine-master/

# Very important to include this after all PKG_ vars are set. This will setup specific package rules which
# will be called when building.
include scripts/OMM_package.mk

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
