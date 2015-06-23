define unpack_method
$(strip \
	$(if $(filter %.zip,$(1)),unzip, \
		$(if $(filter %.tar,$(1)),untar, \
			$(if $(filter local,$(1)),copy, \
			) \
		) \
	) \
)
endef

define UnpackMethod/unzip
$(call shell_with_exit_status,mkdir -p $(1),$(VERBOSE_OUTPUT)) \
$(call shell_with_exit_status,cp -rf $(3)/* $(1),$(VERBOSE_OUTPUT)) \
$(call shell_with_exit_status,unzip -d $1 $2 > /dev/null,$(VERBOSE_OUTPUT))
endef

define UnpackMethod/copy
$(shell mkdir --parents $(1)) \
$(shell cp -rf $(3)/* $(1))
endef
