PKG_NAME := libopencm3
#PKG_REVISION := c28d7bc18782c21429ddab9fc985cfe0f6db375e
PKG_REVISION := master
PKG_URI := https://github.com/libopencm3/libopencm3/archive/$(PKG_REVISION).zip
PKG_INC := libopencm3-$(PKG_REVISION)/include/

include scripts/OMM_package_rules.mk

### This ugly construct is necessary just to remove the last character '-' from the CCPREFIX
define Package/Compile/$(PKG_NAME)
$(eval tmp_space:=) \
$(eval tmp_space+=) \
$(eval tmp_prefix=$(subst -, ,$(CCPREFIX))) \
$(eval tmp_prefix=$(strip $(tmp_prefix))) \
$(eval tmp_prefix=$(subst $(tmp_space),-,$(tmp_prefix))) \
PREFIX=$(tmp_prefix) $(MAKE) -C $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/libopencm3-$(PKG_REVISION)
endef

#define Package/Compile/$(PKG_NAME)
#$(eval retval := $(shell cd $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/libopencm3-master; $(MAKE) > /dev/null; echo $$?)) \
#$(if $(call strequal,$(retval),0),, \
#	$(error Compiling of $(PKG_NAME) failed! retval $(retval)) \
#)
#endef

define Package/BeforeLink/$(PKG_NAME)
	$(eval LINKLIBS := opencm3_stm32f4)
	$(eval LINKERSCRIPT := $(PKG_BASEDIR)/stm32f4-discovery.ld)
	$(eval LD_FLAGS += -L$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/libopencm3-$(PKG_REVISION)/lib/ -l$(LINKLIBS) -T$(LINKERSCRIPT))
endef

$(eval $(call Package/Setup,$(PKG_NAME)))
