PKG_NAME := nrf24xx
PKG_SRC := src/nrf24xx.c
PKG_INC := inc

include scripts/OMM_package_rules.mk

$(eval $(call Package/Setup,$(PKG_NAME)))
