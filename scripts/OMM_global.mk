project_pkg_depends=$(call resolve_deps,project_dep_list,global_resolved_dep_list,global_dependency_chain)
global_pkg_prepare_list=$(patsubst %,$(OMM_PKG_WORK_DIR)/%/prepare,$(project_pkg_depends))
global_pkg_compile_list=$(patsubst %,$(OMM_PKG_WORK_DIR)/%/compile,$(project_pkg_depends))

cur_src=$(patsubst %,$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/%,$(PKG_SRC))
cur_objs=$(cur_src:.c=.o )

define Global/ProjectSetup
	$(eval project_name += $(1))
	$(eval project_dep_list += $(1))
	$(eval project_dep_list += $(2))
endef

define Global/AddGlobalList
	$(eval global_pkg_list += $(1))
endef

define Global/SetupPkgDeps
	$(eval $(call Package/SwitchSet,$(1)))
	$(eval global_dependency_chain += :-$(PKG_NAME) $(PKG_DEPS) -:)
endef

define Global/SetupIncludePaths
	$(eval $(call Package/SwitchSet,$(1)))
	$(eval global_inc_paths += $(patsubst %,$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/%,$(PKG_INC)))
endef

define Global/SetupObjList
	$(eval $(call Package/SwitchSet,$(1)))
	$(eval global_objs += $(cur_objs))
endef
