# Allow to configure xperience settings first
$(call inherit-product, vendor/xperience/config/xperience_configuration.mk)

PRODUCT_BRAND ?= XPerience

#Add TARGET_ARCH By default we suppose is ARM64
TARGET_XPE_ARCH ?= arm64

ifneq ( $(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT), $(space))
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

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/xperience/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/xperience/prebuilt/common/bin/50-xpe.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-xpe.sh

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

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/xperience/config/permissions/backup.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/backup.xml

# xperience-specific broadcast actions whitelist
PRODUCT_COPY_FILES += \
    vendor/xperience/config/permissions/xperience-sysconfig.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/xperience-sysconfig.xml

# Copy all xperience-specific init rc files
$(foreach f,$(wildcard vendor/xperience/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

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
    vendor/xperience/config/permissions/mx.xperience.android.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/mx.xperience.android.xml

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

# Include AOSP audio files
include vendor/xperience/config/aosp_audio.mk

# Include xperience audio files
include vendor/xperience/config/xpe_audio.mk

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# AOSP packages
PRODUCT_PACKAGES += \
    Terminal

# Themes
PRODUCT_PACKAGES += \
    ThemePicker \
    XPerienceWallpapers \
	XPerienceOverlayStub

#SetupWizard
ifneq ($(TARGET_BUILD_VARIANT), eng)
PRODUCT_PACKAGES += \
    XPerienceSetupWizard
endif

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig

# Extra tools in Lineage
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
    nano \
    pigz \
    setcap \
    unrar \
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

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

# Root
PRODUCT_PACKAGES += \
    adb_root

# Dex preopt
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/xperience/overlay
DEVICE_PACKAGE_OVERLAYS += vendor/xperience/overlay/common

# Use signing keys for only official builds
ifeq ($(XPERIENCE_CHANNEL),OFFICIAL)
    PRODUCT_DEFAULT_DEV_CERTIFICATE := .keys/releasekey
    PRODUCT_OTA_PUBLIC_KEYS = .keys/otakey.x509.pem

# Only build OTA if official
PRODUCT_PACKAGES += \
    Updater

endif

PRODUCT_VERSION_MAJOR = 15
PRODUCT_VERSION_MINOR = 1
PRODUCT_VERSION_MAINTENANCE = 0

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
        XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(shell date -u +%Y%m%d)-$(XPE_BUILDTYPE)-$(XPERIENCE_BUILD)
    else
        ifeq ($(TARGET_BUILD_VARIANT),user)
            ifeq ($(XPE_VERSION_MAINTENANCE),0)
                XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(XPERIENCE_BUILD)
            else
                XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(XPERIENCE_BUILD)
            endif
        else
            XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(XPERIENCE_BUILD)
        endif
    endif
else
    ifeq ($(XPE_VERSION_MAINTENANCE),0)
        XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(shell date -u +%Y%m%d)-$(XPE_BUILDTYPE)$(XPE_EXTRAVERSION)-$(XPERIENCE_BUILD)
    else
        XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(shell date -u +%Y%m%d)-$(XPE_BUILDTYPE)$(XPE_EXTRAVERSION)-$(XPERIENCE_BUILD)
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
            XPE_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(TARGET_VENDOR_RELEASE_BUILD_ID)
     endif
endif
endif
#########################################################################
#Newer aditions
# Enable ALLOW_MISSING_DEPENDENCIES on Vendorless Builds
ifeq ($(BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE),)
  ALLOW_MISSING_DEPENDENCIES := true
endif

# Build
BUILD_BROKEN_USES_BUILD_COPY_HEADERS := true

# HIDL
PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    android.hidl.manager@1.0 \
    android.hidl.base@1.0.vendor \
    android.hidl.manager@1.0.vendor
#########################################################################

# TWRP
ifeq ($(WITH_TWRP),true)
include vendor/xperience/config/twrp.mk
endif

# Include Common Qualcomm Device Tree on Qualcomm Boards
# $(call inherit-product-if-exists, device/xperience/common/common.mk)
