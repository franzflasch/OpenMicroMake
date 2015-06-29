global_defines=$(patsubst %,-D%, $(GLOBAL_DEFS))

cur_src=$(filter %.c,$(patsubst %,$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/%,$(PKG_SRC)))
cur_src_cpp=$(filter %.cpp,$(patsubst %,$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/%,$(PKG_SRC)))
cur_asm_src=$(filter %.s,$(patsubst %,$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/%,$(PKG_SRC)))

cur_objs=$(cur_src:.c=.o )
cur_objs+=$(cur_src_cpp:.cpp=.o )
cur_objs+=$(cur_asm_src:.s=.o )

pkg_prepare_depends=$(patsubst %,$(OMM_PKG_WORK_DIR)/%/prepare,$(PKG_DEPS))
pkg_compile_depends=$(patsubst %,$(OMM_PKG_WORK_DIR)/%/compile,$(PKG_DEPS))

define Package/AddGlobalPackageList
	$(eval global_pkg_list += $(1))
endef

define Package/SetupPKGDefault
	$(eval PKG_NAME :=)
	$(eval PKG_DEPS :=)	
	$(eval PKG_URI := local)
	$(eval PKG_SRC :=)
	$(eval PKG_INC :=)
	$(eval PKG_DEFS :=)
	$(eval PKG_CC_FLAGS :=)
	$(eval PKG_PATCHES :=)
	$(eval PKG_BASEDIR :=$(dir $(1)))
	$(eval PKG_REVISION :=)
endef

define Package/SwitchSet
	$(eval PKG_NAME:=$($(1)/PKG_NAME))
	$(eval PKG_DEPS :=$($(1)/PKG_DEPS))
	$(eval PKG_URI:=$($(1)/PKG_URI))
	$(eval PKG_SRC:=$($(1)/PKG_SRC))
	$(eval PKG_INC:=$($(1)/PKG_INC))
	$(eval PKG_DEFS:=$($(1)/PKG_DEFS))
	$(eval PKG_CC_FLAGS:=$($(1)/PKG_CC_FLAGS))
	$(eval PKG_PATCHES:=$($(1)/PKG_PATCHES))
	$(eval PKG_BASEDIR:=$($(1)/PKG_BASEDIR))
	$(eval PKG_REVISION:=$($(1)/PKG_REVISION))
endef

define Package/Setup
	$(eval $(1)/PKG_NAME := $(PKG_NAME))
	$(eval $(1)/PKG_DEPS :=$(PKG_DEPS))	
	$(eval $(1)/PKG_URI := $(PKG_URI))
	$(eval $(1)/PKG_SRC := $(PKG_SRC))
	$(eval $(1)/PKG_INC := $(PKG_INC))
	$(eval $(1)/PKG_DEFS := $(PKG_DEFS))
	$(eval $(1)/PKG_CC_FLAGS := $(PKG_CC_FLAGS))
	$(eval $(1)/PKG_PATCHES := $(PKG_PATCHES))
	$(eval $(1)/PKG_BASEDIR := $(PKG_BASEDIR))
	$(eval $(1)/PKG_REVISION := $(PKG_REVISION))
	$(call Package/AddGlobalPackageList,$(PKG_NAME))
endef

define Package/SetupPkgDeps
	$(foreach item, $(2),
		$(call Package/SwitchSet,$(item))
		$(eval global_dependency_chain += :-$(PKG_NAME) $(PKG_DEPS) -:)
	)
	$(call Package/SwitchSet,$(1))
endef

define Package/SetupAndGetPkgDeps
	$(call Package/SetupPkgDeps,$(2),$(global_pkg_list))
	$(eval global_resolved_dep_list:=)
	$(eval dep_list:=$(3))
	$(eval $(1):=$(call resolve_deps,dep_list,global_resolved_dep_list,global_dependency_chain))
endef

define Package/SetupObjList
	$(eval global_objs:=)
	$(foreach item, $(2),
		$(call Package/SwitchSet,$(item))
		$(eval global_objs+=$(cur_objs))
		$(eval global_objs=$(sort $(global_objs)))
	)
	$(call Package/SwitchSet,$(1))
endef

define Package/SetupPkgIncPaths
	$(eval pkg_inc_paths :=)
	$(foreach item, $(PKG_DEPS),
		$(call Package/SwitchSet,$(item))
		$(eval pkg_inc_paths += $(patsubst %,$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/%,$(PKG_INC)))
		$(eval pkg_inc_paths = $(sort $(pkg_inc_paths)))
	)
	$(call Package/SwitchSet,$(1))
	$(eval pkg_inc_paths += $(patsubst %,$(OMM_PKG_WORK_DIR)/$(PKG_NAME)/%,$(PKG_INC)))
endef

define Package/WritePkgBuildProgress
	$(shell echo $(strip $(1)) >> $(2))
endef

define Package/ReadPkgBuildProgress
	$(shell cat $(1))
endef

define Package/IncludePKG
	$(foreach item,$(1),$(call Package/SetupPKGDefault,$(item))$(eval -include $(item)))
endef
