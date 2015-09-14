include scripts/OMM_config.mk
include scripts/functions/OMM_functions.mk
include scripts/OMM_package_generic.mk
#include scripts/OMM_package_rules.mk --- Must be included only within package.mk

# Dynamically include mk files here
mk_files := $(call find_mk_files,$(OMM_PACKAGE_DIR))
mk_files += $(call find_mk_files,$(PROJECT_PATH))
$(eval $(call Package/IncludePKG,$(mk_files)))

flash: $(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME).hex
	avrdude -cstk500v2 -P/dev/ttyUSB0 -patmega8 -Uflash:w:$(OMM_PKG_DEPLOY_DIR)/$(PKG_NAME).hex

test:
	@echo test
	
clean:
	rm -rf $(OMM_WORK_DIR)/$(PROJECT_NAME)

.PHONY: all test flash clean
