# Apply it to build.prop
PRODUCT_PRODUCT_PROPERTIES += \
    ro.xpe.version=$(XPE_VERSION) \
    ro.xpe.releasetype=$(XPE_BUILDTYPE) \
    ro.xperience.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.xpe.version.minor=$(PRODUCT_VERSION_MAJOR) \
    ro.xpe.version.major=$(PRODUCT_VERSION_MINOR) \
    ro.xpe.channeltype=$(XPERIENCE_CHANNEL) \
    ro.modversion=$(XPE_VERSION) \
    ro.xpe.model=$(XPERIENCE_BUILD) \
    ro.xpe.codename=Cháak \
    ro.xpelegal.url=http://thexperienceproject.klozz.dev/legal/ \
    ro.boot.vendor.overlay.theme=com.android.internal.systemui.navbar.gestural


# Settings props
#PRODUCT_PRODUCT_PROPERTIES += \
    ro.xpe.battery?=$(XPERIENCE_BATTERY) \
    ro.xpe.chipset?=$(XPERIENCE_CHIPSET) \
    ro.xpe.display_resolution?=$(XPERIENCE_DISPLAY) \
    ro.xpe.maintainer?=$(XPERIENCE_MAINTAINER)

PRODUCT_PRODUCT_PROPERTIES += \
    ro.qcom.system=$(shell grep "refs/tags/LA.QSSI" .repo/manifests/default.xml | cut -d '"' -f2 | cut -d "/" -f3) \
    ro.qcom.vendor=$(shell grep "refs/tags/LA.VENDOR" .repo/manifests/default.xml | cut -d '"' -f2 | cut -d "/" -f3) 

#   ro.qcom.system=$(shell grep "refs/tags/android-13.0" .repo/manifests/default.xml | cut -d '"' -f2 | cut -d "/" -f3) \
#   ro.qcom.vendor=LA.UM.9.14.r1-19600.01-LAHAINA.QSSI12.0


PRODUCT_PRODUCT_PROPERTIES += \
    ro.build.stock_fingerprint=$(PRODUCT_OVERRIDE_FINGERPRINT)

# Gaussian Blur
PRODUCT_PRODUCT_PROPERTIES += \
    ro.sf.blurs_are_expensive=1 \
    ro.surface_flinger.supports_background_blur=1

#Version of the ROM
PRODUCT_VERSION_MAJOR = 19
PRODUCT_VERSION_MINOR = 0
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
PRODUCT_EXPERIMENTAL:=1
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
        XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(shell date -u +%Y%m%d)-$(XPE_BUILDTYPE)-$(XPERIENCE_BUILD)s
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
# Signing
ifneq (eng,$(TARGET_BUILD_VARIANT))
ifneq (,$(wildcard vendor/xperience/signing/keys/releasekey.pk8))
PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/xperience/signing/keys/releasekey
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.oem_unlock_supported=1
endif
ifneq (,$(wildcard vendor/xperience/signing/keys/otakey.x509.pem))
PRODUCT_OTA_PUBLIC_KEYS := vendor/xperience/signing/keys/otakey.x509.pem
endif
endif
#########################################################################
#Newer aditions
# Enable ALLOW_MISSING_DEPENDENCIES on Vendorless Builds
ifeq ($(BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE),)
  ALLOW_MISSING_DEPENDENCIES := true
endif

