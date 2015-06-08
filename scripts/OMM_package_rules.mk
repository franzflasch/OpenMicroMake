include scripts/OMM_package.mk

$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/download:
	$(call Package/SwitchSet,$(notdir $(@D)))
	$(call Package/Download/$(PKG_NAME))
	$(call set_timestamp,$(OMM_PKG_WORK_DIR)/$(PKG_NAME),download)
	@echo $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/download done

$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/prepare: $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/download $(call rwildcard, $(PKG_BASEDIR)/, *.c *.h *.mk)
	$(call Package/SwitchSet,$(notdir $(@D)))
	$(call Package/Info/$(PKG_NAME))
	$(call Package/Unpack/$(PKG_NAME))
	$(call Package/Patch/$(PKG_NAME))
	$(call set_timestamp,$(OMM_PKG_WORK_DIR)/$(PKG_NAME),prepare)
	@echo $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/prepare done

$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/compile: $(pkg_compile_depends) $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/prepare $(cur_src)
	$(call Package/SwitchSet,$(notdir $(@D)))
	$(call Package/SetupPkgIncPaths,$(PKG_NAME))
	$(call Package/Compile/$(PKG_NAME))
	$(call Package/WritePkgBuildProgress,$(PKG_NAME),$(OMM_PKG_WORK_DIR)/pkgs_built)
	$(call set_timestamp,$(OMM_PKG_WORK_DIR)/$(PKG_NAME),compile)
	@echo $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/compile done

$(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME)/link: $(OMM_PKG_WORK_DIR)/$(PKG_NAME)/compile
	$(call Package/SwitchSet,$(notdir $(@D)))
	$(call Package/Link/$(PKG_NAME))
	$(call set_timestamp,$(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME),link)
	@echo $(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME)/link done

$(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME).bin: $(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME)/link
	$(CP) -O binary -S $(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME).elf $(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME).bin
	
$(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME).hex: $(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME)/link
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
$(PKG_NAME)/link: $(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME)/link
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