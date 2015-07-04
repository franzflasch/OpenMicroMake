###### Essential settings ######
ifeq ($(strip $(PROJECT)),)
    $(error no project config given...)
else
    include $(PROJECT)
endif

ifeq ($(strip $(ARCH)),)
    $(error ARCH not defined!)
endif

ifeq ($(strip $(MACH)),)
    $(error MACH not defined!)
endif

ifeq ($(strip $(CCPREFIX)),)
    $(error CCPREFIX not defined!)
endif

PROJECT_NAME=$(basename $(notdir $(PROJECT)))
PROJECT_PATH=$(dir $(PROJECT))

VERBOSE_OUTPUT := $(V)


###### User defined settings ######
OMM_PACKAGE_DIR 	= package
OMM_WORK_DIR 		= omm_workdir
OMM_PKG_WORK_DIR   	= $(OMM_WORK_DIR)/$(PROJECT_NAME)/$(MACH)/package
OMM_PKG_DEPLOY_DIR 	= $(OMM_WORK_DIR)/$(PROJECT_NAME)/$(MACH)/deploy
OMM_DOWNLOAD_DIR   	= $(OMM_WORK_DIR)/download
