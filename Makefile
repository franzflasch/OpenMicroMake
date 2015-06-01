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

# Prepare package dependencies
#$(foreach item, $(global_pkg_list),$(eval $(call Global/SetupPkgDeps,$(item))))

#$(eval $(call Package/SwitchSet,omm_common))
#$(eval $(call Global/ProjectSetup,$(PKG_NAME),$(PKG_DEPS)))

# Prepare include paths
#$(foreach item, $(project_pkg_depends), \
#	$(eval $(call Global/SetupIncludePaths,$(item))) \
#	$(eval $(call Global/SetupObjList,$(item))) \
#	$(eval $(call Global/SetupGlobalCompileFlags,$(item))) \
#)

#$(error $(global_inc_paths))

all: $(global_pkg_prepare_list) $(global_pkg_compile_list) $(OMM_PKG_DEPLOY_DIR)/$(project_name).elf
	
$(OMM_PKG_DEPLOY_DIR)/$(project_name).elf: $(global_objs)
	mkdir -p $(OMM_PKG_DEPLOY_DIR)
	$(CC) $(LD_FLAGS) $(global_objs) -o $(OMM_PKG_DEPLOY_DIR)/$(project_name).elf

#### Generic Part END ####

#arm-none-eabi-objcopy -O binary -S test_project.elf test_project.bin

flash: $(OMM_PKG_DEPLOY_DIR)/$(project_name).hex
	avrdude -cstk500v2 -P/dev/ttyUSB1 -patmega8 -Uflash:w:$(OMM_PKG_DEPLOY_DIR)/$(project_name).hex

test:
	@echo global_inc_paths $(global_inc_paths)
	@echo global_objs $(global_objs)
	@echo global_pkg_list $(global_pkg_list)
	@echo global_dependency_chain $(global_dependency_chain)
	@echo project_pkg_depends $(project_pkg_depends)
	@echo project_dep_list $(project_dep_list)

.PHONY: all test
