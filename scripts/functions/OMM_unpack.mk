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
$(shell mkdir --parents $(1)) \
$(eval retval := $(shell unzip -d $1 $2 > /dev/null; echo $$?)) \
$(if $(call strequal,$(retval),0),, \
	$(error unzip of $2 failed! retval $(retval)) \
)
endef

define UnpackMethod/copy
$(shell mkdir --parents $(1)) \
$(shell cp -rf $(3)/* $(1))
endef
