#OMM_PKG_DIRS = package
#OMM_PKG_DIRS += OpenMicroMake
#OMM_PKG_DIRS += $(OMM_USER_PROJECT)

OMM_PACKAGE_DIR = package

OMM_DEPEND_FILE = .omm_depend
OMM_CONFIG_FILE = .omm_config
OMM_WORK_DIR = omm_workdir
OMM_WORK_DIR_ARCH = $(OMM_WORK_DIR)/$(OMM_USER_PROJECT)/$(OMM_ARCH_CONFIG)/$(OMM_MACH_MCU_CONFIG)
OMM_WORK_SRC_DIR = $(OMM_WORK_DIR_ARCH)/src
OMM_DEPLOY_DIR = $(OMM_WORK_DIR_ARCH)/deploy

OMM_TIMESTAMP_DIR = $(OMM_WORK_DIR)/omm_timestamps

OMM_PKG_WORK_DIR = $(OMM_WORK_DIR)/$(PROJECT)/$(MACH)/package
OMM_DOWNLOAD_DIR = $(OMM_WORK_DIR)/download