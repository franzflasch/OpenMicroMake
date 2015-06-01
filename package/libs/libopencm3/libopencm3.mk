PKG_NAME := libopencm3
PKG_URI := https://github.com/libopencm3/libopencm3/archive/master.zip
PKG_INC := libopencm3-master/include/

include scripts/OMM_package.mk

define Package/Compile/$(PKG_NAME)
$(eval retval := $(shell cd $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/libopencm3-master; $(MAKE) > /dev/null; echo $$?)) \
$(if $(call strequal,$(retval),0),, \
	$(error Compiling of $(PKG_NAME) failed! retval $(retval)) \
)
endef

define Package/BeforeLink/$(PKG_NAME)
	$(eval LINKLIBS := opencm3_stm32f4)
	$(eval LINKERSCRIPT := $(PKG_BASEDIR)/stm32f4-discovery.ld)
	$(eval LD_FLAGS += -L$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/libopencm3-master/lib/ -l$(LINKLIBS) -T$(LINKERSCRIPT))
endef

$(eval $(call Package/Setup,$(PKG_NAME)))
