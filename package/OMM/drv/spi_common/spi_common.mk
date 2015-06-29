PKG_NAME := spi_common
PKG_SRC := src/spi_common.c
PKG_INC := inc

include scripts/OMM_package_rules.mk

$(eval $(call Package/Setup,$(PKG_NAME)))
