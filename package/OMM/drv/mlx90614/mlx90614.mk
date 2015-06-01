PKG_NAME := mlx90614
PKG_SRC := src/mlx90614.c
PKG_INC := inc

include scripts/OMM_package.mk


$(eval $(call Package/Setup,$(PKG_NAME)))
