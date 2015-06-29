PKG_NAME := soft_spi
PKG_DEPS := spi_common
PKG_SRC := src/soft_spi.c
PKG_INC := inc

include scripts/OMM_package_rules.mk

$(eval $(call Package/Setup,$(PKG_NAME)))
