define Package/Reset
	$(eval PKG_NAME :=)
	$(eval PKG_DEPS :=)	
	$(eval PKG_URI :=)
	$(eval PKG_SRC :=)
	$(eval PKG_INC :=)
	$(eval PKG_DEFS :=)
	$(eval PKG_BASEDIR :=)
endef

define Package/SwitchSet
	$(eval PKG_NAME:=$($(1)/PKG_NAME))
	$(eval PKG_DEPS :=$($(1)/PKG_DEPS))
	$(eval PKG_URI:=$($(1)/PKG_URI))
	$(eval PKG_SRC:=$($(1)/PKG_SRC))
	$(eval PKG_INC:=$($(1)/PKG_INC))
	$(eval PKG_DEFS :=$($(1)/PKG_DEFS))
	$(eval PKG_BASEDIR:=$($(1)/PKG_BASEDIR))
endef

define Package/Setup
	$(eval $(1)/PKG_NAME := $(PKG_NAME))
	$(eval $(1)/PKG_DEPS :=$(PKG_DEPS))	
	$(eval $(1)/PKG_URI := $(PKG_URI))
	$(eval $(1)/PKG_SRC := $(PKG_SRC))
	$(eval $(1)/PKG_INC := $(PKG_INC))
	$(eval $(1)/PKG_DEFS := $(PKG_DEFS))
	$(eval $(1)/PKG_BASEDIR := $(PKG_BASEDIR))
	$(eval $(call Global/AddGlobalList,$(PKG_NAME)))
	$(eval $(call Package/Reset))
endef

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

$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/download:
	$(eval $(call Package/SwitchSet,$(notdir $(@D))))
	$(eval $(call Package/Download/$(PKG_NAME)))
	$(eval $(call set_timestamp,$(OMM_PKG_WORK_DIR)/$(PKG_NAME),download))
	@echo $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/download done

$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/prepare: $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/download $(PKG_BASEDIR)/*
	$(eval $(call Package/SwitchSet,$(notdir $(@D))))
	$(eval $(call Package/$(PKG_NAME)/Info))
	$(eval $(call Package/Unpack/$(PKG_NAME)))
	$(eval $(call set_timestamp,$(OMM_PKG_WORK_DIR)/$(PKG_NAME),prepare))
	@echo $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/prepare done

$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/compile: $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/prepare $(cur_src)
	$(eval $(call Package/SwitchSet,$(notdir $(@D))))
	$(eval tmp_inc_paths := $(patsubst %,-I%, $(global_inc_paths)))
	$(eval tmp_defs := $(patsubst %,-D%, $(PKG_DEFS)))
	$(CC) $(OPTIONAL_CC_FLAGS) $(DDEFS) $(tmp_defs) $(tmp_inc_paths) -c $(cur_src) -o $(cur_objs)
	$(eval $(call set_timestamp,$(OMM_PKG_WORK_DIR)/$(PKG_NAME),compile))
	@echo $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/compile done

$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/clean:
	$(eval $(call Package/SwitchSet,$(notdir $(@D))))
	rm -rf $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/compile
	rm -rf $(cur_objs)

$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/dirclean:
	$(eval $(call Package/SwitchSet,$(notdir $(@D))))
	rm -rf $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/

.PHONY: $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/clean
