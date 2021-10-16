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
    XPeriaWeather \
    Terminal

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig

# Wallet app for Power menu integration
# https://source.android.com/devices/tech/connect/quick-access-wallet
#PRODUCT_PACKAGES += \
#    QuickAccessWallet

# Use signing keys for only official builds
ifeq ($(XPERIENCE_CHANNEL),OFFICIAL)
    PRODUCT_DEFAULT_DEV_CERTIFICATE := .keys/releasekey
    PRODUCT_OTA_PUBLIC_KEYS = .keys/otakey.x509.pem

# Signing
-include vendor/xperience/signing/keys.mk

# Only build OTA if official
#PRODUCT_PACKAGES += \
#    Updater

# XPerience postboot based on qcom file
#PRODUCT_PACKAGES += \
#    init.xperience.postboot.sh

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
    SystemUI \
    Settings \
    XPeriaWeather

#-include vendor/qcom/common/perf/packages.mk

# if exist track perf changes
#-include vendor/extras/extras.mk

ifeq ($(WITH_GMS), true)

-include vendor/gapps/pixel-gapps.mk

endif


