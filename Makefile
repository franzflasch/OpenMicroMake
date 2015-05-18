CCPREFIX	= avr-
CC   		= $(CCPREFIX)gcc
CP   		= $(CCPREFIX)objcopy
ODUMP       = $(CCPREFIX)objdump
SZ 			= $(CCPREFIX)size
AS   		= $(CCPREFIX)gcc -x assembler-with-cpp
RM 			= rm -rf
MCU  		= atmega8

OPTIONAL_CC_FLAGS	= -mmcu=$(MCU) -Os

GLOBAL_DEFS = "F_CPU=1000000"
$(eval DDEFS := $(patsubst %,-D%, $(GLOBAL_DEFS)))

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
#include scripts/OMM_package.mk

include scripts/OMM_global.mk

# include packages here
include $(call find_mk_files,$(OMM_PACKAGE_DIR))
include $(call find_mk_files,$(PROJECT))

# Prepare package dependencies
$(foreach item, $(global_pkg_list),$(eval $(call Global/SetupPkgDeps,$(item))))

# Prepare include paths
$(foreach item, $(project_pkg_depends),$(eval $(call Global/SetupIncludePaths,$(item)))$(eval $(call Global/SetupObjList,$(item))))

all: $(global_pkg_prepare_list) $(global_pkg_compile_list) $(project_name).elf

$(project_name).elf: $(global_objs)
	$(CC) $(OPTIONAL_CC_FLAGS) $(global_objs) -o $(project_name).elf

test:
	@echo global_inc_paths $(global_inc_paths)
	@echo global_objs $(global_objs)
	@echo global_pkg_list $(global_pkg_list)
	@echo global_dependency_chain $(global_dependency_chain)
	@echo project_pkg_depends $(project_pkg_depends)
	@echo project_dep_list $(project_dep_list)

.PHONY: all test
