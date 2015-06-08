ifeq ($(strip $(PROJ_CONF)),)
$(error no project config given...)
else
include $(PROJ_CONF)
endif

ifeq ($(strip $(CCPREFIX)),)
$(error CCPREFIX not defined!)
endif

ifeq ($(strip $(PROJECT)),)
$(error PROJECT not defined!)
endif

ifeq ($(strip $(ARCH)),)
$(error ARCH not defined!)
endif

ifeq ($(strip $(MACH)),)
$(error MACH not defined!)
endif

include scripts/OMM_config.mk
include scripts/functions/OMM_functions.mk
include scripts/OMM_package_generic.mk
#include scripts/OMM_package_rules.mk --- Must be included only within package.mk

# Dynamically include mk files here
mk_files := $(call find_mk_files,$(OMM_PACKAGE_DIR))
mk_files += $(call find_mk_files,$(PROJECT))
$(eval $(call Package/IncludePKG,$(mk_files)))


flash: $(OMM_PKG_DEPLOY_DIR)/$(project_name).hex
	avrdude -cstk500v2 -P/dev/ttyUSB1 -patmega8 -Uflash:w:$(OMM_PKG_DEPLOY_DIR)/$(project_name).hex

test:
	@echo test

.PHONY: all test
