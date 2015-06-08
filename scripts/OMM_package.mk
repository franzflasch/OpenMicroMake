include scripts/functions/OMM_functions.mk
include scripts/functions/OMM_depend.mk
include scripts/functions/OMM_download.mk
include scripts/functions/OMM_unpack.mk

### Functions for building packages: ###
#define Package/Download/$(PKG_NAME)

define Package/Download/$(PKG_NAME)
	$(if $(strip $(PKG_URI)), \
		$(call DownloadMethod/$(call dl_method,$(PKG_URI)),$(OMM_DOWNLOAD_DIR)/$(PKG_NAME),$(PKG_URI)) \
		, \
		$(info No PKG_URI for $(PKG_NAME)) \
	)
endef

define Package/Unpack/$(PKG_NAME)
	$(if $(strip $(PKG_URI)), \
		$(call UnpackMethod/$(call unpack_method,$(notdir $(PKG_URI))),$(OMM_PKG_WORK_DIR)/$(PKG_NAME),$(OMM_DOWNLOAD_DIR)/$(PKG_NAME)/$(notdir $(PKG_URI)),$(PKG_BASEDIR)) \
		, \
		$(info No PKG_URI for $(PKG_NAME)) \
	)
endef

define Package/Patch/$(PKG_NAME)
	$(if $(strip $(PKG_PATCHES)), \
		$(eval tmp_omm_basedir:=$(PWD)) \
		$(eval tmp_patches:=$(patsubst %,$(tmp_omm_basedir)/$(PKG_BASEDIR)%,$(PKG_PATCHES))) \
		cd $(OMM_PKG_WORK_DIR)/$(PKG_NAME); \
		quilt import $(tmp_patches); \
		quilt push -a; \
		cd $(tmp_omm_basedir); \
		$(info $(tmp_patches)) \
		, \
		$(info No PKG_PATCHES for $(PKG_NAME)) \
	)
endef

#define Package/Info/$(PKG_NAME)
#	$(info Package info:)
#	$(info PKG_NAME $(PKG_NAME))
#	$(info PKG_DEPS $(PKG_DEPS))
#	$(info PKG_URI $(PKG_URI))
#	$(info PKG_SRC $(PKG_SRC))
#	$(info PKG_ASM_SRC $(PKG_ASM_SRC))
#	$(info PKG_INC $(PKG_INC))
#	$(info PKG_DEFS $(PKG_DEFS))
#	$(info PKG_CC_FLAGS $(PKG_CC_FLAGS))
#	$(info PKG_LD_FLAGS $(PKG_LD_FLAGS))
#	$(info PKG_BASEDIR $(PKG_BASEDIR))
#	$(info PKG_GLOBAL_DEFS $(PKG_GLOBAL_DEFS))
#endef

define Package/Compile/$(PKG_NAME)
	$(eval tmp_inc_paths := $(patsubst %,-I%, $(pkg_inc_paths))) \
	$(eval tmp_defs := $(patsubst %,-D%, $(PKG_DEFS))) \
	$(foreach item,$(cur_src), \
		$(CC) $(CC_FLAGS) $(PKG_CC_FLAGS) $(global_defines) $(tmp_defs) $(tmp_inc_paths) -c $(item) -o $(item:.c=.o ); \
		$(newline) \
	) \
	$(foreach item,$(cur_asm_src), \
		$(AS) $(AS_FLAGS) -c $(item) -o $(item:.s=.o ); \
	)
endef

define Package/Link/$(PKG_NAME)
	$(eval tmp_cur_pkg_name:=$(PKG_NAME)) \
	mkdir -p $(OMM_PKG_DEPLOY_DIR) \
	$(eval objs_to_link:=$(call Package/SetupAndGetPkgDeps,$(PKG_NAME),$(PKG_DEPS))) \
	$(eval objs_to_link+=$(PKG_NAME)) \
	$(foreach item,$(objs_to_link), \
		$(call Package/SwitchSet,$(item)) \
		$(call Package/BeforeLink/$(item)) \
	) \
	$(call Package/SwitchSet,$(tmp_cur_pkg_name)) \
	$(call Package/SetupObjList,$(PKG_NAME),$(objs_to_link)) \
	$(CC) $(global_objs) $(LD_FLAGS) -o $(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME).elf
endef