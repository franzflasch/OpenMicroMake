#### Generic Part ####

ifeq ($(strip $(LOCAL_CONF)),)
$(info no mach config given...)
else
include $(LOCAL_CONF)
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

OMM: all

include scripts/OMM_config.mk
include scripts/OMM_functions.mk
include scripts/OMM_depend.mk
include scripts/OMM_download.mk
#include scripts/OMM_package.mk --- Must be included only within package.mk
include scripts/OMM_global.mk

# Dynamically include mk files here
mk_files := $(call find_mk_files,$(OMM_PACKAGE_DIR))
mk_files += $(call find_mk_files,$(PROJECT))
$(eval $(call Global/IncludePKG,$(mk_files)))

# OLD:
# Prepare package dependencies
#$(foreach item, $(global_pkg_list),$(eval $(call Global/SetupPkgDeps,$(item))))

all: $(global_pkg_prepare_list) $(global_pkg_compile_list) $(OMM_PKG_DEPLOY_DIR)/$(project_name).elf
	
$(OMM_PKG_DEPLOY_DIR)/$(project_name).elf: $(global_objs)
	mkdir -p $(OMM_PKG_DEPLOY_DIR)
	$(CC) $(LD_FLAGS) $(global_objs) -o $(OMM_PKG_DEPLOY_DIR)/$(project_name).elf

#### Generic Part END ####

#arm-none-eabi-objcopy -O binary -S test_project.elf test_project.bin

flash: $(OMM_PKG_DEPLOY_DIR)/$(project_name).hex
	avrdude -cstk500v2 -P/dev/ttyUSB1 -patmega8 -Uflash:w:$(OMM_PKG_DEPLOY_DIR)/$(project_name).hex

test:
	@echo test

.PHONY: all test
