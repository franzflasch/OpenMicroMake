### OLD - but left here, maybe it is useful later
#project_pkg_depends=$(call resolve_deps,project_dep_list,global_resolved_dep_list,global_dependency_chain)
#global_pkg_prepare_list=$(patsubst %,$(OMM_PKG_WORK_DIR)/%/prepare,$(project_pkg_depends))
#global_pkg_compile_list=$(patsubst %,$(OMM_PKG_WORK_DIR)/%/compile,$(project_pkg_depends))

#define Global/ProjectSetup
#	$(eval project_name += $(1))
#	$(eval project_dep_list += $(1))
#	$(eval project_dep_list += $(2))
#endef


#define Global/SetupIncludePaths
#	$(eval $(call Package/SwitchSet,$(1)))
#	$(eval global_inc_paths += $(patsubst %,$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/%,$(PKG_INC)))
#	$(eval global_inc_paths = $(sort $(global_inc_paths)))
#endef

global_defines=$(patsubst %,-D%, $(GLOBAL_DEFS))

cur_src=$(patsubst %,$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/%,$(PKG_SRC))
cur_asm_src=$(patsubst %,$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/%,$(PKG_ASM_SRC))
cur_objs=$(cur_src:.c=.o )
cur_objs+=$(cur_asm_src:.s=.o )

pkg_prepare_depends=$(patsubst %,$(OMM_PKG_WORK_DIR)/%/prepare,$(PKG_DEPS))
pkg_compile_depends=$(patsubst %,$(OMM_PKG_WORK_DIR)/%/compile,$(PKG_DEPS))

define Global/AddGlobalPackageList
	$(eval $(call Package/SwitchSet,$(1)))
	$(eval global_pkg_list += $(PKG_NAME))
endef

define Global/SetupPkgDeps
$(foreach item, $(2), \
	$(eval $(call Package/SwitchSet,$(item))) \
	$(eval global_dependency_chain += :-$(PKG_NAME) $(PKG_DEPS) -:) \
) \
$(eval $(call Package/SwitchSet,$(1)))
endef

define Global/GetPkgDeps
$(eval global_resolved_dep_list:=) \
$(eval dep_list:=$(1)) \
$(eval pkg_depends:=$(call resolve_deps,dep_list,global_resolved_dep_list,global_dependency_chain)) \
$(pkg_depends)
endef

define Global/SetupAndGetPkgDeps
$(call Global/SetupPkgDeps,$(1),$(global_pkg_list)) \
$(call Global/GetPkgDeps,$(2))
endef

define Global/SetupObjList
	$(eval global_objs :=) \
	$(foreach item, $(1), \
		$(eval $(call Package/SwitchSet,$(item))) \
		$(eval global_objs += $(cur_objs)) \
		$(eval global_objs = $(sort $(global_objs))) \
	)
endef

define Global/WritePkgBuildProgress
	$(shell echo $(strip $(1)) >> $(2))
endef

define Global/ReadPkgBuildProgress
	$(shell cat $(1))
endef

define Global/SetupPKGDefault
	$(eval PKG_NAME :=)
	$(eval PKG_DEPS :=)	
	$(eval PKG_URI := local)
	$(eval PKG_SRC :=)
	$(eval PKG_ASM_SRC :=)
	$(eval PKG_INC :=)
	$(eval PKG_DEFS :=)
	$(eval PKG_CC_FLAGS:=)
	$(eval PKG_PATCHES:=)
	$(eval PKG_BASEDIR :=$(dir $(1)))
endef

define Global/IncludePKG
$(foreach item,$(1),$(call Global/SetupPKGDefault,$(item))$(eval -include $(item)))
endef
