# Additional packages
# themes
# $(call inherit-product, vendor/themes/themes.mk)

# Include AOSP audio files
include vendor/xperience/config/aosp_audio.mk

# Include xperience audio files
include vendor/xperience/config/xpe_audio.mk

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# Telephony
PRODUCT_PACKAGES += \
    ims-ext-common \
    ims_ext_common.xml \
    qti-telephony-hidl-wrapper \
    qti_telephony_hidl_wrapper.xml \
    qti-telephony-utils \
    qti_telephony_utils.xml \
    telephony-ext

#PRODUCT_BOOT_JARS += \
#    telephony-ext

# CellBroadcastReceiver
PRODUCT_PACKAGES += \
CellBroadcastReceiver

# Exchange support
PRODUCT_PACKAGES += \
    Exchange2

# Additional apps
# PRODUCT_PACKAGES += \
#    Etar \
#    ExactCalculator \
#    NightFallQuickStep \
#    OmniStyle \
#    Terminal \
#    XPeriaWeather \
#    Yunikon
PRODUCT_PACKAGES += \
    NightFallQuickStep \
    Seedvault \
    Terminal \
    XPeriaWeather

# Dummy for the weather
PRODUCT_PACKAGES += \
	com.sony.device

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig

# Wallet app for Power menu integration
# https://source.android.com/devices/tech/connect/quick-access-wallet
PRODUCT_PACKAGES += \
    QuickAccessWallet

# Use signing keys for only official builds
ifeq ($(XPERIENCE_CHANNEL),OFFICIAL)
    PRODUCT_DEFAULT_DEV_CERTIFICATE := .keys/releasekey
    PRODUCT_OTA_PUBLIC_KEYS = .keys/otakey.x509.pem

# Only build OTA if official
#PRODUCT_PACKAGES += \
#    Updater

# XPerience postboot based on qcom file
PRODUCT_PACKAGES += \
    init.xperience.postboot.sh

endif

#SetupWizard
#ifneq ($(TARGET_BUILD_VARIANT), eng)
#PRODUCT_PACKAGES += \
#    XPerienceSetupWizard
#endif

PRODUCT_PACKAGES += \
    charger_res_images \
    cm_charger_res_images \
    font_log.png \
    libhealthd.lineage

# FS tools
PRODUCT_PACKAGES += \
    fsck.exfat \
    fsck.ntfs \
    mount.ntfs \
    mke2fs \
    mkfs.exfat \
    mkfs.ntfs

# Permissions
PRODUCT_PACKAGES += \
    privapp-permissions-xperience.xml \
    privapp-permissions-xperience-product.xml \
    privapp-permissions-xperience-system_ext.xml

# Exempt DeskClock from Powersave
PRODUCT_PACKAGES += \
    deskclock.xml

# Backup Services whitelist
PRODUCT_PACKAGES += \
    backup.xml

# Hidden API whitelist
PRODUCT_PACKAGES += \
    xperience-hiddenapi-package-whitelist.xml

# Themes
PRODUCT_PACKAGES += \
    ThemePicker \
    WallpaperPicker2 \
    XPerienceOverlayStub

#Coral cant include this due to lower superpartition size
ifneq ($(TARGET_DONT_INCLUDE_XPEWALLS), true)
PRODUCT_PACKAGES += \
    XPerienceWallpapers
endif

PRODUCT_PACKAGES += \
    NavigationBarMode2ButtonOverlay

# Dex preopt
PRODUCT_DEXPREOPT_SPEED_APPS += \
    NightFallQuickStep \
    SystemUI \
    Settings \
    XPeriaWeather


ifneq ($(strip $(TARGET_USES_RRO)),true)
# enable overlays to use our version of
# source/resources etc.
DEVICE_PACKAGE_OVERLAYS += device/qcom/common/device/overlay
PRODUCT_PACKAGE_OVERLAYS += device/qcom/common/product/overlay
endif

-include vendor/xperience/xperience-performance/common/perf-common.mk

# if exist track perf changes
-include vendor/extras/extras.mk

ifeq ($(WITH_GMS), true)

# -include vendor/gapps/pixel-gapps.mk
$(call inherit-product, vendor/gapps/common/common-vendor.mk)

PRODUCT_PACKAGES += \
    XPerienceSetupWizard

# SetupWizard and Google Assistant properties
PRODUCT_PRODUCT_PROPERTIES += \
    setupwizard.theme=glif_v3_light \
    setupwizard.feature.skip_button_use_mobile_data.carrier1839=true \
    setupwizard.feature.show_pai_screen_in_main_flow.carrier1839=false \
    setupwizard.feature.show_pixel_tos=true \
    setupwizard.feature.baseline_setupwizard_enabled=true \
    ro.setupwizard.esim_cid_ignore=00000001 \
    setupwizard.feature.show_support_link_in_deferred_setup=false \
    ro.setupwizard.rotation_locked=true \
    ro.opa.eligible_device=true

# Gboard side padding
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.ime.kb_pad_port_l=4 \
    ro.com.google.ime.kb_pad_port_r=4 \
    ro.com.google.ime.kb_pad_land_l=64 \
    ro.com.google.ime.kb_pad_land_r=64 \

endif
