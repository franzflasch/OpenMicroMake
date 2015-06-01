define Package/SwitchSet
	$(eval PKG_NAME:=$($(1)/PKG_NAME))
	$(eval PKG_DEPS :=$($(1)/PKG_DEPS))
	$(eval PKG_URI:=$($(1)/PKG_URI))
	$(eval PKG_SRC:=$($(1)/PKG_SRC))
	$(eval PKG_ASM_SRC:=$($(1)/PKG_ASM_SRC))
	$(eval PKG_INC:=$($(1)/PKG_INC))
	$(eval PKG_DEFS:=$($(1)/PKG_DEFS))
	$(eval PKG_CC_FLAGS:=$($(1)/PKG_CC_FLAGS))
	$(eval PKG_BASEDIR:=$($(1)/PKG_BASEDIR))
endef

define Package/Setup
	$(eval $(1)/PKG_NAME := $(PKG_NAME))
	$(eval $(1)/PKG_DEPS :=$(PKG_DEPS))	
	$(eval $(1)/PKG_URI := $(PKG_URI))
	$(eval $(1)/PKG_SRC := $(PKG_SRC))
	$(eval $(1)/PKG_ASM_SRC := $(PKG_ASM_SRC))
	$(eval $(1)/PKG_INC := $(PKG_INC))
	$(eval $(1)/PKG_DEFS := $(PKG_DEFS))
	$(eval $(1)/PKG_CC_FLAGS := $(PKG_CC_FLAGS))
	$(eval $(1)/PKG_BASEDIR := $(PKG_BASEDIR))
	$(eval $(call Global/AddGlobalPackageList,$(PKG_NAME)))
endef

define Package/SetupPkgIncPaths
$(eval pkg_inc_paths :=) \
$(foreach item, $(PKG_DEPS), \
	$(eval $(call Package/SwitchSet,$(item))) \
	$(eval pkg_inc_paths += $(patsubst %,$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/%,$(PKG_INC))) \
	$(eval pkg_inc_paths = $(sort $(pkg_inc_paths))) \
) \
$(eval $(call Package/SwitchSet,$(1))) \
$(eval pkg_inc_paths += $(patsubst %,$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/%,$(PKG_INC)))
endef

#$(eval $(call Global/SetupIncludePaths,$(PKG_NAME)))
#$(eval $(call Global/SetupObjList,$(item)))
#$(eval $(call Global/SetupGlobalCompileFlags,$(item)))

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

define Package/Download/$(PKG_NAME)
	$(if $(call strequal,$(PKG_URI),local), \
		$(info Local PKG: $(PKG_NAME)) \
		,
		$(if $(strip $(PKG_URI)), \
			$(info Hey there is a PKG_URI for package $(PKG_NAME) - $(PKG_URI)) \
			$(info Using default method) \
			$(call DownloadMethod/$(call dl_method,$(PKG_URI)),$(OMM_DOWNLOAD_DIR)/$(PKG_NAME),$(PKG_URI)) \
			, \
			$(info No PKG_URI for $(PKG_NAME)) \
		) \
	)
endef

define Package/Unpack/$(PKG_NAME)
	$(if $(call strequal,$(PKG_URI),local), \
		$(if $(strip $(PKG_BASEDIR)), \
			$(call CopyMethod/default,$(OMM_PKG_WORK_DIR)/$(PKG_NAME),$(PKG_BASEDIR)) \
			,$(info No PKG_BASEDIR for $(PKG_NAME)) \
		) \
		, \
		$(if $(strip $(PKG_URI)), \
			$(call UnpackMethod/$(call unpack_method,$(notdir $(PKG_URI))),$(OMM_PKG_WORK_DIR)/$(PKG_NAME),$(OMM_DOWNLOAD_DIR)/$(PKG_NAME)/$(notdir $(PKG_URI)),$(PKG_NAME),$(OMM_PKG_WORK_DIR)/$(PKG_NAME)) \
			, \
			$(info No PKG_URI for $(PKG_NAME)) \
		) \
	)
endef

#$(eval $(shell cd $(OMM_PKG_WORK_DIR)/$(PKG_NAME); ))

define Package/Patch/$(PKG_NAME)
	$(eval $(info hey i am the patch function!!!))
endef

define Package/Compile/$(PKG_NAME)
$(eval tmp_inc_paths := $(patsubst %,-I%, $(pkg_inc_paths)))
$(eval tmp_defs := $(patsubst %,-D%, $(PKG_DEFS)))
$(foreach item,$(cur_src), \
	$(info $(CC) $(CC_FLAGS) $(PKG_CC_FLAGS) $(global_defines) $(tmp_defs) $(tmp_inc_paths) -c $(item) -o $(item:.c=.o ))
	$(eval retval := $(shell $(CC) $(CC_FLAGS) $(PKG_CC_FLAGS) $(global_defines) $(tmp_defs) $(tmp_inc_paths) -c $(item) -o $(item:.c=.o ); echo $$?)) \
	$(if $(call strequal,$(retval),0),, \
		$(error Compiling of $(item) failed! retval $(retval)) \
	) \
) \
$(foreach item,$(cur_asm_src), \
	$(eval retval := $(shell $(AS) $(AS_FLAGS) -c $(item) -o $(item:.s=.o ); echo $$?)) \
	$(if $(call strequal,$(retval),0),, \
		$(error Compiling of $(item) failed! retval $(retval)) \
	) \
)
endef

pkg_prepare_depends:=$(patsubst %,$(OMM_PKG_WORK_DIR)/%/prepare,$(PKG_DEPS))
pkg_compile_depends:=$(patsubst %,$(OMM_PKG_WORK_DIR)/%/compile,$(PKG_DEPS))

$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/download:
	$(eval $(call Package/SwitchSet,$(notdir $(@D))))
	$(eval $(call Package/Download/$(PKG_NAME)))
	$(eval $(call set_timestamp,$(OMM_PKG_WORK_DIR)/$(PKG_NAME),download))
	@echo $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/download done

$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/prepare: $(pkg_prepare_depends) $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/download $(call rwildcard, $(PKG_BASEDIR)/, *.c *.h *.mk)
	$(eval $(call Package/SwitchSet,$(notdir $(@D))))
	$(eval $(call Package/Info/$(PKG_NAME)))
	$(eval $(call Package/Unpack/$(PKG_NAME)))
	$(eval $(call Package/Patch/$(PKG_NAME)))
	$(eval $(call set_timestamp,$(OMM_PKG_WORK_DIR)/$(PKG_NAME),prepare))
	@echo $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/prepare done

$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/compile: $(pkg_compile_depends) $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/prepare $(cur_src)
	$(eval $(call Package/SwitchSet,$(notdir $(@D))))
	$(eval $(call Package/SetupPkgIncPaths,$(PKG_NAME)))
	$(eval $(info compiling $(PKG_NAME)))
	$(eval $(info pkg_inc_paths $(pkg_inc_paths)))
	$(eval $(call Package/Compile/$(PKG_NAME)))
	$(eval $(call Global/WritePkgBuildProgress,$(PKG_NAME),$(OMM_PKG_WORK_DIR)/pkgs_built))
	$(eval $(call set_timestamp,$(OMM_PKG_WORK_DIR)/$(PKG_NAME),compile))
	@echo $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/compile done

$(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME).elf: $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/compile
	mkdir -p $(OMM_PKG_DEPLOY_DIR)
	$(eval objs_so_far:=$(call Global/ReadPkgBuildProgress,$(OMM_PKG_WORK_DIR)/pkgs_built))
	$(foreach item,$(objs_so_far),$(call Package/SwitchSet,$(item))$(call Package/BeforeLink/$(item)))
	$(eval $(call Global/SetupObjList,$(objs_so_far)))
	$(CC) $(global_objs) $(LD_FLAGS) -o $(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME).elf
	@echo objs_so_far: $(objs_so_far)

$(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME).bin: $(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME).elf
	$(CP) -O binary -S $(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME).elf $(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME).bin
	
$(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME).hex: $(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME).elf
	$(CP) -R .eeprom -R .fuse -R .lock -R .signature -O ihex $(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME).elf $(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME).hex

$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/clean:
	$(eval $(call Package/SwitchSet,$(notdir $(@D))))
	rm -rf $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/compile
	rm -rf $(cur_objs)

$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/dirclean:
	$(eval $(call Package/SwitchSet,$(notdir $(@D))))
	rm -rf $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/

#### Shortcut rules:
$(PKG_NAME)/download: $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/download
$(PKG_NAME)/prepare: $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/prepare
$(PKG_NAME)/compile: $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/compile
$(PKG_NAME)/link: $(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME).elf
$(PKG_NAME)/bin: $(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME).bin
$(PKG_NAME)/hex: $(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME).hex
$(PKG_NAME)/clean: $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/clean
$(PKG_NAME)/dirclean: $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/dirclean

.PHONY: \
$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/clean \
$(PKG_NAME)/download \
$(PKG_NAME)/prepare \
$(PKG_NAME)/compile \
$(PKG_NAME)/link \
$(PKG_NAME)/bin \
$(PKG_NAME)/hex \
$(PKG_NAME)/clean \
$(PKG_NAME)/dirclean
