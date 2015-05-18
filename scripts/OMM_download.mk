# Try to guess the download method from the URL
define dl_method
$(strip \
  $(if $(filter @GNOME/% @GNU/% @KERNEL/% @SF/% @SAVANNAH/% ftp://% http://% https://% file://%,$(1)),default, \
    $(if $(filter git://%,$(1)),git, \
      $(if $(filter svn://%,$(1)),svn, \
        $(if $(filter cvs://%,$(1)),cvs, \
          $(if $(filter hg://%,$(1)),hg, \
            $(if $(filter sftp://%,$(1)),bzr, \
              unknown \
            ) \
          ) \
        ) \
      ) \
    ) \
  ) \
)
endef

define DownloadMethod/git
$(info git clone $2 $1)
endef

#define DownloadMethod/default
#$(if $(call check_timestamp,$(4),$(3)_download), \
#	$(info Package:$(3) is already downloaded), \
#	$(shell mkdir --parents $(1)) \
#	$(eval retval := $(shell wget -P $1 $2; echo $$?)) \
#	$(if $(call strequal,$(retval),0),  \
#		$(call set_timestamp,$(4),$(3)_download), \
#		$(error download of $1 failed! retval $(retval)) \
#	) \
#)
#endef

define DownloadMethod/default
$(shell mkdir --parents $(1)) \
$(eval retval := $(shell wget -nc -P $1 $2; echo $$?)) \
$(if $(call strequal,$(retval),0),, \
	$(error download of $1 failed! retval $(retval)) \
)
endef

define CopyMethod/default
$(shell mkdir --parents $(1)) \
$(shell cp -rf $(2)/* $(1))
endef

define unpack_method
$(strip \
	$(if $(filter %.zip,$(1)),unzip, \
		$(if $(filter %.tar,$(1)),untar, \
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

