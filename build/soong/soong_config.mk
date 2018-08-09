# Insert new variables inside the XPerience structure
SOONG_CONFIG_NAMESPACES += Xperience

define add-xperience-var
$(eval SOONG_CONFIG_Xperience += $(strip $(1)))
$(eval SOONG_CONFIG_Xperience_$(strip $(1)) := $(2))
endef

add_xperience_bool = $(eval $(call add-xperience-var,$(1),$(if $(filter true,$(2)),true,false)))
add_xperience_var = $(eval $(call add-xperience-var,$(1),$(2)))

$(call add_xperience_bool,    Has_legacy_camera_hal1,             $(TARGET_HAS_LEGACY_CAMERA_HAL1))
$(call add_xperience_bool,    Needs_text_relocations,             $(TARGET_NEEDS_PLATFORM_TEXT_RELOCATIONS))
$(call add_xperience_var,     Specific_camera_parameter_library,  $(TARGET_SPECIFIC_CAMERA_PARAMETER_LIBRARY))
$(call add_xperience_var,     Target_shim_libs,                   $(subst $(space),:,$(TARGET_LD_SHIM_LIBS)))
$(call add_xperience_var,     Uses_generic_camera_parameter_library, $(if $(TARGET_SPECIFIC_CAMERA_PARAMETER_LIBRARY),false,true))
$(call add_xperience_bool,    Uses_nvidia_enhancements,           $(NV_ANDROID_FRAMEWORK_ENHANCEMENTS))
$(call add_xperience_bool,    Uses_qcom_bsp_legacy,               $(TARGET_USES_QCOM_BSP_LEGACY))
$(call add_xperience_bool,    Uses_qti_camera_device,             $(TARGET_USES_QTI_CAMERA_DEVICE))
