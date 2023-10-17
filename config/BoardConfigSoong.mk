PATH_OVERRIDE_SOONG := $(shell echo $(TOOLS_PATH_OVERRIDE))

# Add variables that we wish to make available to soong here.
EXPORT_TO_SOONG := \
    KERNEL_ARCH \
    KERNEL_BUILD_OUT_PREFIX \
    KERNEL_CROSS_COMPILE \
    KERNEL_MAKE_CMD \
    KERNEL_MAKE_FLAGS \
    PATH_OVERRIDE_SOONG \
    TARGET_KERNEL_CONFIG \
    TARGET_KERNEL_SOURCE \
    TARGET_PREBUILT_KERNEL_HEADERS

# Setup SOONG_CONFIG_* vars to export the vars listed above.
# Documentation here:
# https://github.com/LineageOS/android_build_soong/commit/8328367c44085b948c003116c0ed74a047237a69

$(call add_soong_config_namespace,xperienceVarsPlugin)
$(foreach v,$(EXPORT_TO_SOONG),$(eval $(call add_soong_config_var,xperienceVarsPlugin,$(v))))

SOONG_CONFIG_NAMESPACES += xperienceGlobalVars
SOONG_CONFIG_xperienceGlobalVars += \
    target_ld_shim_libs \
    include_miui_camera \
    uses_miui_camera \
    uses_oplus_camera \
    uses_nothing_camera \
    camera_needs_miui_camera_mode_support \
    camera_needs_camera_needs_depth_sensor_override

# Soong bool variables
SOONG_CONFIG_xperienceGlobalVars_include_miui_camera := $(TARGET_INCLUDES_MIUI_CAMERA)
SOONG_CONFIG_xperienceGlobalVars_uses_miui_camera := $(TARGET_USES_MIUI_CAMERA)

# Soong value variables
SOONG_CONFIG_xperienceGlobalVars_target_ld_shim_libs := $(subst $(space),:,$(TARGET_LD_SHIM_LIBS))
SOONG_CONFIG_xperienceGlobalVars_uses_oplus_camera := $(TARGET_USES_OPLUS_CAMERA)
SOONG_CONFIG_xperienceGlobalVars_uses_nothing_camera := $(TARGET_USES_NOTHING_CAMERA)
SOONG_CONFIG_xperienceGlobalVars_camera_needs_miui_camera_mode_support := $(TARGET_USES_MIUI_CAMERA)
SOONG_CONFIG_xperienceGlobalVars_camera_needs_camera_needs_depth_sensor_override := $(TARGET_USES_DEPTHSENSOR_OVERRIDE)

# Disable qmi EAP-SIM security
DISABLE_EAP_PROXY := true

# Qualcomm variables
#SOONG_CONFIG_NAMESPACES += aosp_vs_qva
#SOONG_CONFIG_aosp_vs_qva += aosp_or_qva
#SOONG_CONFIG_aosp_vs_qva_aosp_or_qva := qva

#SOONG_CONFIG_NAMESPACES += bredr_vs_btadva
#SOONG_CONFIG_bredr_vs_btadva += bredr_or_btadva

#ifneq "$(wildcard vendor/qcom/proprietary/commonsys/bt/bt_adv_audio)" ""
#    $(warning bt_adv_audio dir is present)
#    SOONG_CONFIG_bredr_vs_btadva_bredr_or_btadva := btadva
#else
#    $(warning bt_adv_audio dir is not present)
#    SOONG_CONFIG_bredr_vs_btadva_bredr_or_btadva := bredr
#endif #ifneq "$(wildcard vendor/qcom/proprietary/commonsys/bt/bt_adv_audio)" ""

# Camera
ifneq ($(TARGET_CAMERA_OVERRIDE_FORMAT_FROM_RESERVED),)
    $(warning TARGET_CAMERA_OVERRIDE_FORMAT_FROM_RESERVED is deprecated, please migrate to soong_config_set,camera,override_format_from_reserved)
    $(call soong_config_set,camera,override_format_from_reserved,$(TARGET_CAMERA_OVERRIDE_FORMAT_FROM_RESERVED))
endif

ifneq ($(TARGET_CAMERA_PACKAGE_NAME),)
    $(call soong_config_set,camera,package_name,$(TARGET_CAMERA_PACKAGE_NAME))
endif

ifneq ($(TARGET_CAMERA_SERVICE_EXT_LIB),)
    $(call soong_config_set,libcameraservice,ext_lib,$(TARGET_CAMERA_SERVICE_EXT_LIB))
endif

# Libui
ifneq ($(TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS),)
    $(call soong_config_set,libui,additional_gralloc_10_usage_bits,$(TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS))
endif

# Lineage Health HAL
ifneq ($(TARGET_HEALTH_CHARGING_CONTROL_CHARGING_PATH),)
    $(warning TARGET_HEALTH_CHARGING_CONTROL_CHARGING_PATH is deprecated, please migrate to soong_config_set,lineage_health,charging_control_charging_path)
    $(call soong_config_set,lineage_health,charging_control_charging_path,$(TARGET_HEALTH_CHARGING_CONTROL_CHARGING_PATH))
endif
ifneq ($(TARGET_HEALTH_CHARGING_CONTROL_DEADLINE_PATH),)
    $(warning TARGET_HEALTH_CHARGING_CONTROL_DEADLINE_PATH is deprecated, please migrate to soong_config_set,lineage_health,charging_control_deadline_path)
    $(call soong_config_set,lineage_health,charging_control_deadline_path,$(TARGET_HEALTH_CHARGING_CONTROL_DEADLINE_PATH))
endif
ifneq ($(TARGET_HEALTH_CHARGING_CONTROL_CHARGING_ENABLED),)
    $(warning TARGET_HEALTH_CHARGING_CONTROL_CHARGING_ENABLED is deprecated, please migrate to soong_config_set,lineage_health,charging_control_charging_enabled)
    $(call soong_config_set,lineage_health,charging_control_charging_enabled,$(TARGET_HEALTH_CHARGING_CONTROL_CHARGING_ENABLED))
endif
ifneq ($(TARGET_HEALTH_CHARGING_CONTROL_CHARGING_DISABLED),)
    $(warning TARGET_HEALTH_CHARGING_CONTROL_CHARGING_DISABLED is deprecated, please migrate to soong_config_set,lineage_health,charging_control_charging_disabled)
    $(call soong_config_set,lineage_health,charging_control_charging_disabled,$(TARGET_HEALTH_CHARGING_CONTROL_CHARGING_DISABLED))
endif
ifneq ($(TARGET_HEALTH_CHARGING_CONTROL_SUPPORTS_BYPASS),)
    $(warning TARGET_HEALTH_CHARGING_CONTROL_SUPPORTS_BYPASS is deprecated, please migrate to soong_config_set,lineage_health,charging_control_supports_bypass)
    $(call soong_config_set,lineage_health,charging_control_supports_bypass,$(TARGET_HEALTH_CHARGING_CONTROL_SUPPORTS_BYPASS))
endif
ifneq ($(TARGET_HEALTH_CHARGING_CONTROL_SUPPORTS_DEADLINE),)
    $(warning TARGET_HEALTH_CHARGING_CONTROL_SUPPORTS_DEADLINE is deprecated, please migrate to soong_config_set,lineage_health,charging_control_supports_deadline)
    $(call soong_config_set,lineage_health,charging_control_supports_deadline,$(TARGET_HEALTH_CHARGING_CONTROL_SUPPORTS_DEADLINE))
endif
ifneq ($(TARGET_HEALTH_CHARGING_CONTROL_SUPPORTS_LIMIT),)
    $(warning TARGET_HEALTH_CHARGING_CONTROL_SUPPORTS_LIMIT is deprecated, please migrate to soong_config_set,lineage_health,charging_control_supports_limit)
    $(call soong_config_set,lineage_health,charging_control_supports_limit,$(TARGET_HEALTH_CHARGING_CONTROL_SUPPORTS_LIMIT))
endif
ifneq ($(TARGET_HEALTH_CHARGING_CONTROL_SUPPORTS_TOGGLE),)
    $(warning TARGET_HEALTH_CHARGING_CONTROL_SUPPORTS_TOGGLE is deprecated, please migrate to soong_config_set,lineage_health,charging_control_supports_toggle)
    $(call soong_config_set,lineage_health,charging_control_supports_toggle,$(TARGET_HEALTH_CHARGING_CONTROL_SUPPORTS_TOGGLE))
endif

# Surfaceflinger
ifneq ($(TARGET_SURFACEFLINGER_UDFPS_LIB),)
    $(warning TARGET_SURFACEFLINGER_UDFPS_LIB is deprecated, please migrate to soong_config_set,surfaceflinger,udfps_lib)
    $(call soong_config_set,surfaceflinger,udfps_lib,$(TARGET_SURFACEFLINGER_UDFPS_LIB))
endif

# Lineage PowerShare HAL
ifneq ($(TARGET_POWERSHARE_PATH),)
    $(call soong_config_set,lineage_powershare,powershare_path,$(TARGET_POWERSHARE_PATH))
endif
ifneq ($(TARGET_POWERSHARE_ENABLED),)
    $(call soong_config_set,lineage_powershare,powershare_enabled,$(TARGET_POWERSHARE_ENABLED))
endif
ifneq ($(TARGET_POWERSHARE_DISABLED),)
    $(call soong_config_set,lineage_powershare,powershare_disabled,$(TARGET_POWERSHARE_DISABLED))
endif

# Power HAL
ifneq ($(TARGET_POWER_LIBPERFMGR_MODE_EXTENSION_LIB),)
    $(call soong_config_set,power_libperfmgr,mode_extension_lib,$(TARGET_POWER_LIBPERFMGR_MODE_EXTENSION_LIB))
endif

# Recovery
ifneq ($(BOOTLOADER_MESSAGE_OFFSET),)
    $(call soong_config_set,lineage_recovery,bootloader_message_offset,$(BOOTLOADER_MESSAGE_OFFSET))
endif

# Vendor init
ifneq ($(TARGET_INIT_VENDOR_LIB),)
    $(warning TARGET_INIT_VENDOR_LIB is deprecated, please migrate to soong_config_set,libinit,vendor_init_lib)
    $(call soong_config_set,libinit,vendor_init_lib,$(TARGET_INIT_VENDOR_LIB))
endif
