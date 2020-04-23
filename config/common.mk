PRODUCT_BRAND ?= XPerience

#Add TARGET_ARCH By default we suppose is ARM64
TARGET_XPE_ARCH ?= arm64

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ "$(TARGET_SCREEN_WIDTH)" -lt "$(TARGET_SCREEN_HEIGHT)" ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

 # get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,,$(shell ls -1 vendor/xperience/prebuilt/common/bootanimation | sort -rn))

 # find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then \
    if [ "$(1)" -le "$(TARGET_BOOTANIMATION_SIZE)" ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

PRODUCT_BOOTANIMATION := vendor/xperience/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip

#We aren't using this old form anymore so for now i will use all other info with copy file then i will change it
PRODUCT_COPY_FILES += $(PRODUCT_BOOTANIMATION):$(TARGET_COPY_OUT_SYSTEM)/media/bootanimation.zip

endif

#well I add ringtones here for all devices
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.config.ringtone=XPerienceRing.ogg \
    ro.config.notification_sound=Reminder.ogg \
    ro.config.alarm_alert=Fuego.ogg

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    keyguard.no_require_sim=true \
    ro.opa.elegible_device=true \
    setupwizard.theme=glif_v3

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.dun.override=0
endif

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Disable Rescue Party
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.sys.disable_rescue=true

# Lower RAM devices
ifeq ($(XPE_LOW_RAM_DEVICE), true)
TARGET_BOOTANIMATION_TEXTURE_CACHE := false
TARGET_HAS_LOW_RAM := true

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    config.disable_atlas=true \
    dalvik.vm.jit.codecachesize=0 \
    persist.sys.force_highendgfx=true \
    ro.config.low_ram=true \
    ro.config.max_starting_bg=8 \
    ro.sys.fw.bg_apps_limit=16
endif

# Copy over the changelog to the device
PRODUCT_COPY_FILES += \
    vendor/xperience/DONATORS.mkdn:$(TARGET_COPY_OUT_SYSTEM)/etc/donators.txt

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/xperience/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/xperience/prebuilt/common/bin/50-xpe.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-xpe.sh \
    vendor/xperience/prebuilt/common/bin/blacklist:$(TARGET_COPY_OUT_SYSTEM)/addon.d/blacklist

ifneq ($(AB_OTA_PARTITIONS),)
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/xperience/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/xperience/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif
endif

# Clean up packages cache to avoid wrong strings and resources
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/bin/clean_cache.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/clean_cache.sh

# Fonts
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/common/fonts/GoogleSans-Regular.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/GoogleSans-Regular.ttf \
    vendor/xperience/prebuilt/common/fonts/GoogleSans-Medium.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/GoogleSans-Medium.ttf \
    vendor/xperience/prebuilt/common/fonts/GoogleSans-MediumItalic.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/GoogleSans-MediumItalic.ttf \
    vendor/xperience/prebuilt/common/fonts/GoogleSans-Italic.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/GoogleSans-Italic.ttf \
    vendor/xperience/prebuilt/common/fonts/GoogleSans-Bold.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/GoogleSans-Bold.ttf \
    vendor/xperience/prebuilt/common/fonts/GoogleSans-BoldItalic.ttf:$(TARGET_COPY_OUT_SYSTEM)/fonts/GoogleSans-BoldItalic.ttf

#Falcon Tweaking
ifeq ($(XPE_BUILD), falcon)
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/common/etc/init.d/01XPerienceKernelCOnf:$(TARGET_COPY_OUT_SYSTEM)/etc/init.d/01XPerienceKernelCOnf
endif

ifeq ($(XPE_BUILD), ghost)
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/common/etc/init.d/02XPerienceColorcalib:$(TARGET_COPY_OUT_SYSTEM)/etc/init.d/02XPerienceColorcalib
endif

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/xperience/config/permissions/backup.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/backup.xml

# init.d support
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/common/etc/init.d/00banner:$(TARGET_COPY_OUT_SYSTEM)/etc/init.d/00banner \
    vendor/xperience/prebuilt/common/bin/sysinit:$(TARGET_COPY_OUT_SYSTEM)/bin/sysinit

ifneq ($(TARGET_BUILD_VARIANT),user)
# userinit support
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/common/etc/init.d/90userinit:$(TARGET_COPY_OUT_SYSTEM)/etc/init.d/90userinit
endif

# Copy all xperience-specific init rc files
$(foreach f,$(wildcard vendor/xperience/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/common/lib/content-types.properties:$(TARGET_COPY_OUT_SYSTEM)/lib/content-types.properties

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/xperience/config/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.nfc.beam.xml

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/Vendor_045e_Product_0719.kl

# This is xperience!
PRODUCT_COPY_FILES += \
    vendor/xperience/config/permissions/mx.xperience.android.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/mx.xperience.android.xml \
    vendor/xperience/config/permissions/privapp-permissions-xpe-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-xpe-product.xml \
    vendor/xperience/config/permissions/privapp-permissions-xpe-system.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-xpe-system.xml

# Hidden API whitelist
PRODUCT_COPY_FILES += \
    vendor/xperience/config/permissions/xperience-hiddenapi-package-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/xperience-hiddenapi-package-whitelist.xml

# Power whitelist
PRODUCT_COPY_FILES += \
    vendor/xperience/config/permissions/xperience-power-whitelist.xml:system/etc/sysconfig/xperience-power-whitelist.xml

# Markup Google
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/lib/libsketchology_native.so:system/lib/libsketchology_native.so \
    vendor/xperience/prebuilt/lib64/libsketchology_native.so:system/lib64/libsketchology_native.so

# Use signing keys for only official builds
ifeq ($(XPERIENCE_CHANNEL),OFFICIAL)
    PRODUCT_DEFAULT_DEV_CERTIFICATE := .keys/releasekey
    PRODUCT_OTA_PUBLIC_KEYS = .keys/otakey.x509.pem

# Only build OTA if official
PRODUCT_PACKAGES += \
    Updater

endif

#XPerience colour :v well not is from xpe but It will be added here so..
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.ime.theme_id=4

# Face Unlock
TARGET_FACE_UNLOCK_SUPPORTED ?= false

ifeq ($(TARGET_XPE_ARCH), arm64)
ifneq ($(TARGET_DISABLE_ALTERNATIVE_FACE_UNLOCK), true)
PRODUCT_PACKAGES += \
    FaceUnlockService
TARGET_FACE_UNLOCK_SUPPORTED := true
endif
endif

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.face.moto_unlock_service=$(TARGET_FACE_UNLOCK_SUPPORTED)

# TWRP
ifeq ($(WITH_TWRP),true)
include vendor/xperience/config/twrp.mk
endif

# Include Common Qualcomm Device Tree on Qualcomm Boards
$(call inherit-product-if-exists, device/xperience/common/common.mk)

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

#SetupWizard
ifneq ($(TARGET_BUILD_VARIANT), eng)
    PRODUCT_PACKAGES += \
    XPerienceSetupWizard
endif

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

PRODUCT_PACKAGES += \
    Longshot \
    MarkupGoogle \
    OmniStyle

ifeq ($(TARGET_XPE_ARCH), arm64)
PRODUCT_PACKAGES += \
    Turbo
endif

ifneq ($(PRODUCT_SIZE), mini)
# Required XPe packages
PRODUCT_PACKAGES += \
    BluetoothExt \
    Development \
    DownloadProvider \
    MediaProvider

# Optional packages
PRODUCT_PACKAGES += \
    libemoji \
    Terminal

PRODUCT_DEXPREOPT_SPEED_APPS += \
    NightFallQuickStep \
    Settings \
    SystemUI \
    XMusic \
    XPerienceOverlayStub

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# Custom packages
PRODUCT_PACKAGES += \
    Alessa \
    CommandCenter3 \
    ExactCalculator \
    DeskClock \
    Launcher3QuickStep \
    NightFallQuickStep \
    Notes \
    SubstratumSignature \
    WeatherClient \
    XPeriaHome \
    XMusic \
    XPeriaWeather \
    XPerienceWallpapers \
    XPerienceOverlayStub \
    Yunikon
else
# Required XPe packages
PRODUCT_PACKAGES += \
    BluetoothExt \
    DownloadProvider \
    MediaProvider

# Optional packages
PRODUCT_PACKAGES += \
    libemoji \
    Terminal

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# Custom packages
PRODUCT_PACKAGES += \
    Alessa \
    CommandCenter3 \
    ExactCalculator \
    Notes \
    NightFallQuickStepGo \
    Launcher3QuickStepGo \
    WeatherClient \
    XMusic \
    XPerienceOverlayStub \
    Yunikon

PRODUCT_DEXPREOPT_SPEED_APPS += \
    NightFallQuickStepGo \
    Settings \
    SystemUI \
    XMusic
endif

# ThemePicker
PRODUCT_PACKAGES += \
    ThemePicker

# Exchange support
PRODUCT_PACKAGES += \
    Exchange2

# Include AOSP audio files
include vendor/xperience/config/aosp_audio.mk

# Include xperience audio files
include vendor/xperience/config/xpe_audio.mk

# Extra tools
PRODUCT_PACKAGES += \
    7z \
    awk \
    bash \
    bzip2 \
    curl \
    getcap \
    htop \
    lib7z \
    libsepol \
    pigz \
    powertop \
    setcap \
    unrar \
    unzip \
    vim \
    wget \
    zip

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.exfat \
    fsck.ntfs \
    mke2fs \
    mkfs.exfat \
    mkfs.ntfs \
    mount.ntfs

# Charger
PRODUCT_PACKAGES += \
    charger_res_images \

# Custom off-mode charger
ifneq ($(WITH_XPE_CHARGER),false)
PRODUCT_PACKAGES += \
    xpe_charger_res_images \
    font_log.png \
    libhealthd.xpe
endif

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    micro_bench \
    procmem \
    procrank \
    strace

# Conditionally build in su
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su
endif
endif

DEVICE_PACKAGE_OVERLAYS += \
    vendor/xperience/overlay/common

PRODUCT_VERSION_MAJOR = 14
PRODUCT_VERSION_MINOR = 0
PRODUCT_VERSION_MAINTENANCE = 0
PRODUCT_NAME = Quetzalcoatlite

ifndef XPERIENCE_CHANNEL
    XPERIENCE_CHANNEL := UNOFFICIAL
endif

XPE_ARCH :=$(TARGET_ARCH)

###########################################################################
# Set XPE_BUILDTYPE from the env RELEASE_TYPE
ifeq ($(TARGET_VENDOR_SHOW_MAINTENANCE_VERSION),true)
    XPE_VERSION_MAINTENANCE := $(PRODUCT_VERSION_MAINTENANCE)
else
    XPE_VERSION_MAINTENANCE := 0
endif

# Set XPE_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat

ifndef XPE_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "XPE_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^XPE_||g')
        XPE_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# Filter out random types, so it'll reset to UNOFFICIAL
ifeq ($(filter RELEASE NIGHTLY HOMEBREW WEEKLY SNAPSHOT EXPERIMENTAL STABLERELEASE,$(XPE_BUILDTYPE)),)
    XPE_BUILDTYPE :=
endif

ifdef XPE_BUILDTYPE
    ifneq ($(XPE_BUILDTYPE), SNAPSHOT)
        ifdef XPE_EXTRAVERSION
            # Force build type to EXPERIMENTAL
            XPE_BUILDTYPE := EXPERIMENTAL
            # Remove leading dash from XPE_EXTRAVERSION
            XPE_EXTRAVERSION := $(shell echo $(XPE_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to XPE_EXTRAVERSION
            XPE_EXTRAVERSION := -$(XPE_EXTRAVERSION)
        endif
    else
        ifndef XPE_EXTRAVERSION
            # Force build type to EXPERIMENTAL, SNAPSHOT mandates a tag
            XPE_BUILDTYPE := EXPERIMENTAL
        else
            # Remove leading dash from XPE_EXTRAVERSION
            XPE_EXTRAVERSION := $(shell echo $(XPE_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to XPE_EXTRAVERSION
            XPE_EXTRAVERSION := -$(XPE_EXTRAVERSION)
        endif
    endif
else
    # If XPE_BUILDTYPE is not defined, set to UNOFFICIAL
ifeq ($(PRODUCT_EXPERIMENTAL),1)
    XPE_BUILDTYPE := EXPERIMENTAL
    XPE_EXTRAVERSION :=
else
    XPE_BUILDTYPE := HOMEBREW
    XPE_EXTRAVERSION :=
endif
endif

ifeq ($(XPE_BUILDTYPE), UNOFFICIAL HOMEBREW)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        XPE_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

ifeq ($(XPE_BUILDTYPE), RELEASE)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
        XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(shell date -u +%Y%m%d)-$(XPE_BUILDTYPE)-$(XPERIENCE_BUILD)-$(PRODUCT_NAME)
    else
        ifeq ($(TARGET_BUILD_VARIANT),user)
            ifeq ($(XPE_VERSION_MAINTENANCE),0)
                XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(XPERIENCE_BUILD)-$(PRODUCT_NAME)
            else
                XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(XPERIENCE_BUILD)-$(PRODUCT_NAME)
            endif
        else
            XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(XPERIENCE_BUILD)-$(PRODUCT_NAME)
        endif
    endif
else
    ifeq ($(XPE_VERSION_MAINTENANCE),0)
        XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(shell date -u +%Y%m%d)-$(XPE_BUILDTYPE)$(XPE_EXTRAVERSION)-$(XPERIENCE_BUILD)-$(PRODUCT_NAME)
    else
        XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(shell date -u +%Y%m%d)-$(XPE_BUILDTYPE)$(XPE_EXTRAVERSION)-$(XPERIENCE_BUILD)-$(PRODUCT_NAME)
    endif
endif

###########################################################################
-include vendor/XPe-priv/keys/keys.mk

ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),)
ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),build/target/product/security/testkey)
    ifneq ($(XPE_BUILDTYPE), UNOFFICIAL)
        ifndef TARGET_VENDOR_RELEASE_BUILD_ID
            ifneq ($(XPE_EXTRAVERSION),)
        		# Remove leading dash from XPE_EXTRAVERSION
                XPE_EXTRAVERSION := $(shell echo $(XPE_EXTRAVERSION) | sed 's/-//')
                TARGET_VENDOR_RELEASE_BUILD_ID := $(XPE_EXTRAVERSION)
            else
                TARGET_VENDOR_RELEASE_BUILD_ID := $(shell date -u +%Y%m%d)
            endif
        else
            TARGET_VENDOR_RELEASE_BUILD_ID := $(TARGET_VENDOR_RELEASE_BUILD_ID)
        endif
            XPE_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(PRODUCT_NAME)
     endif
endif
endif
#########################################################################3
#Newer aditions
# Enable ALLOW_MISSING_DEPENDENCIES on Vendorless Builds
ifeq ($(BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE),)
  ALLOW_MISSING_DEPENDENCIES := true
endif

# HIDL 
PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    android.hidl.manager@1.0 \
    android.hidl.base@1.0.vendor \
    android.hidl.manager@1.0.vendor
