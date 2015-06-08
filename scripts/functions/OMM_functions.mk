#### Helper functions

define strequal
$(and $(findstring $(1),$(2)),$(findstring $(2),$(1)))
endef

define find_mk_files
$(shell find $(1) -type f -name '*.mk')
endef

define whereami
$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))	
endef

define get_basedir
$(dir $(call whereami))
endef

define get_pre_last_makefile
$(lastword $(filter-out $(lastword $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))	
endef

define get_pre_last_makefile_directory
$(dir $(call get_pre_last_makefile))	
endef

define rwildcard
$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))
endef

define check_timestamp
$(wildcard $(1)/$(2))
endef

define set_timestamp
$(shell mkdir -p $(1)) \
$(shell touch $(1)/$(2))
endef

define newline

endef
