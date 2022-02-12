# Additional packages

# Include AOSP audio files
include vendor/xperience/config/aosp_audio.mk

# Include xperience audio files
include vendor/xperience/config/xpe_audio.mk

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

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

# Repainter integration
PRODUCT_PACKAGES += \
    RepainterServicePriv

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
PRODUCT_PACKAGES += \
    Updater

# XPerience postboot based on qcom file
PRODUCT_PACKAGES += \
    init.xperience.postboot.sh

endif

# Charger
PRODUCT_PACKAGES += \
    charger_res_images

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
    LatinIME \
    LatinIMEGooglePrebuilt \
    NightFallQuickStep \
    Phonesky \
    SystemUI \
    Settings \
    Velvet \
    XPeriaWeather


ifneq ($(strip $(TARGET_USES_RRO)),true)
# enable overlays to use our version of
# source/resources etc.
ifeq ($(TARGET_USE_QTI_BT_STACK),true)
DEVICE_PACKAGE_OVERLAYS += device/qcom/common/device/overlay
PRODUCT_PACKAGE_OVERLAYS += device/qcom/common/product/overlay
else
DEVICE_PACKAGE_OVERLAYS += vendor/xperience/overlay/qcom/common/device/overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/xperience/overlay/qcom/common/product/overlay
endif #TARGET_USE_QTI_BT_STACK
endif #TARGET_USES_RRO

# -include vendor/xperience/xperience-performance/common/perf-common.mk

# if exist track perf changes
-include vendor/extras/extras.mk

ifeq ($(WITH_GMS), true)

# -include vendor/gapps/pixel-gapps.mk
$(call inherit-product, vendor/gapps/common/common-vendor.mk)

PRODUCT_PACKAGES += \
    XPerienceSetupWizard

# Gboard side padding
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.ime.kb_pad_port_l=4 \
    ro.com.google.ime.kb_pad_port_r=4 \
    ro.com.google.ime.kb_pad_land_l=64 \
    ro.com.google.ime.kb_pad_land_r=64 \

endif
