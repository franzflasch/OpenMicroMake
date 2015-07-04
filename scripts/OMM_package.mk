include scripts/functions/OMM_functions.mk
include scripts/functions/OMM_depend.mk
include scripts/functions/OMM_download.mk
include scripts/functions/OMM_unpack.mk

### Functions for building packages: ###

define Package/Download/$(PKG_NAME)
	$(if $(strip $(PKG_URI)), \
		$(call DownloadMethod/$(call dl_method,$(PKG_URI)),$(OMM_DOWNLOAD_DIR)/$(PKG_NAME),$(PKG_URI),$(VERBOSE_OUTPUT)) \
		, \
		$(error No PKG_URI for $(PKG_NAME)) \
	)
endef

define Package/Unpack/$(PKG_NAME)
	$(if $(strip $(PKG_URI)), \
		$(call UnpackMethod/$(call unpack_method,$(notdir $(PKG_URI))),$(OMM_PKG_WORK_DIR)/$(PKG_NAME),$(OMM_DOWNLOAD_DIR)/$(PKG_NAME)/$(notdir $(PKG_URI)),$(PKG_BASEDIR)) \
		, \
		$(error No PKG_URI for $(PKG_NAME)) \
	)
endef

define Package/Patch/$(PKG_NAME)
	$(if $(strip $(PKG_PATCHES)), \
		$(eval tmp_omm_basedir:=$(PWD)) \
		$(eval tmp_patches:=$(patsubst %,$(tmp_omm_basedir)/$(PKG_BASEDIR)%,$(PKG_PATCHES))) \
		$(call shell_with_exit_status,./scripts/functions/quilt_patch.sh "$(tmp_omm_basedir)" "$(OMM_PKG_WORK_DIR)/$(PKG_NAME)" "$(tmp_patches)",$(VERBOSE_OUTPUT))
		, \
	)
endef

define Package/Info/$(PKG_NAME)
	$(info Package info:)
	$(info PKG_NAME = $(PKG_NAME))
	$(info PKG_DEPS = $(PKG_DEPS))
	$(info PKG_URI = $(PKG_URI))
	$(info PKG_SRC = $(PKG_SRC))
	$(info PKG_INC = $(PKG_INC))
	$(info PKG_DEFS = $(PKG_DEFS))
	$(info PKG_CC_FLAGS = $(PKG_CC_FLAGS))
	$(info PKG_LD_FLAGS = $(PKG_LD_FLAGS))
	$(info PKG_BASEDIR = $(PKG_BASEDIR))
endef

define Package/Compile/$(PKG_NAME)
	$(eval tmp_inc_paths := $(patsubst %,-I%, $(pkg_inc_paths)))
	$(eval tmp_defs := $(patsubst %,-D%, $(PKG_DEFS)))
	$(foreach item,$(cur_src),
		$(call shell_with_exit_status,$(CC) $(CC_FLAGS) $(PKG_CC_FLAGS) $(global_defines) $(tmp_defs) $(tmp_inc_paths) -c $(item) -o $(item:.c=.o ),$(VERBOSE_OUTPUT))
	)
	$(foreach item,$(cur_src_cpp),
		$(call shell_with_exit_status,$(CPP) $(CPP_FLAGS) $(PKG_CC_FLAGS) $(global_defines) $(tmp_defs) $(tmp_inc_paths) -c $(item) -o $(item:.cpp=.o ),$(VERBOSE_OUTPUT))
	)
	$(foreach item,$(cur_asm_src),
		$(call shell_with_exit_status,$(AS) $(AS_FLAGS) -c $(item) -o $(item:.s=.o ),$(VERBOSE_OUTPUT))
	)
endef

define Package/Link/$(PKG_NAME)
	$(eval tmp_cur_pkg_name:=$(PKG_NAME))
	$(call Package/SetupAndGetPkgDeps,objs_to_link,$(PKG_NAME),$(PKG_DEPS))
	$(eval objs_to_link+=$(PKG_NAME))
	$(foreach item,$(objs_to_link),
		$(call Package/SwitchSet,$(item))
		$(call Package/BeforeLink/$(item))
	)
	$(call Package/SwitchSet,$(tmp_cur_pkg_name))
	$(call Package/SetupObjList,$(PKG_NAME),$(objs_to_link))
	$(call shell_with_exit_status,mkdir -p $(OMM_PKG_DEPLOY_DIR),$(VERBOSE_OUTPUT))
	$(call shell_with_exit_status,$(CC) $(global_objs) $(LD_FLAGS) -o $(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME).elf,$(VERBOSE_OUTPUT))
	$(SZ) $(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME).elf
endef

define Package/Clean/$(PKG_NAME)
	rm -rf $(cur_objs)
endef

define Package/Dirclean/$(PKG_NAME)
	rm -rf $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/
endef