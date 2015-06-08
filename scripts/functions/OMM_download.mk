# Try to guess the download method from the URL
define dl_method
$(strip \
  $(if $(filter @GNOME/% @GNU/% @KERNEL/% @SF/% @SAVANNAH/% ftp://% http://% https://% file://%,$(1)),default, \
    $(if $(filter git://%,$(1)),git, \
      $(if $(filter svn://%,$(1)),svn, \
        $(if $(filter cvs://%,$(1)),cvs, \
          $(if $(filter hg://%,$(1)),hg, \
          	$(if $(filter local,$(1)),do_nothing, \
            	$(if $(filter sftp://%,$(1)),bzr, \
              	  unknown \
              ) \
            ) \
          ) \
        ) \
      ) \
    ) \
  ) \
)
endef

define DownloadMethod/do_nothing
$(info Local Package $(notdir $(1)))
endef

define DownloadMethod/git
git clone $2 $3
endef

define DownloadMethod/default
$(shell mkdir --parents $(1)) \
$(eval retval := $(shell wget -nc -P $1 $2; echo $$?)) \
$(if $(call strequal,$(retval),0),, \
	$(error download of $1 failed! retval $(retval)) \
)
endef
