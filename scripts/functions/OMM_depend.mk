#### PKG dependency handling

define dependency_check
$(foreach item, $2, $(if $(filter $(item),$1),,$(item)))
endef

define get_pkg_deps
$(strip \
	$(eval BEGIN:=) \
	$(eval PKG_DEPENDS_ON := ) \
	$(foreach item,$(2), \
		$(if $(call strequal,:-$1,$(item)),$(eval BEGIN := 1),) \
		$(if $(call strequal,-:,$(item)),$(eval BEGIN := ),) \
		$(if $(BEGIN),$(eval PKG_DEPENDS_ON += $(item)),) \
	) \
	$(filter-out :-$1,$(PKG_DEPENDS_ON)) \
)
endef

define _resolve_deps
$(strip \
	$(foreach dep_item,$(call get_pkg_deps,$(1),${$(3)}), \
		$(eval $(2)+=$(dep_item)) \
		$(call _resolve_deps,$(dep_item),$(2),$(3)) \
	) \
)
endef

define resolve_deps
$(strip \
	$(foreach app_item,${$(1)}, \
		$(eval $(2)+=$(app_item)) \
		$(call _resolve_deps,$(app_item),$(2),$(3)) \
	) \
	$(sort ${$(2)}) \
)
endef
