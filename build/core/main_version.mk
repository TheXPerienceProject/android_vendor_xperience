# Apply it to build.prop
ADDITIONAL_SYSTEM_PROPERTIES += \
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
#ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.xpe.battery?=$(XPERIENCE_BATTERY) \
    ro.xpe.chipset?=$(XPERIENCE_CHIPSET) \
    ro.xpe.display_resolution?=$(XPERIENCE_DISPLAY) \
    ro.xpe.maintainer?=$(XPERIENCE_MAINTAINER)

ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.qcom.system=$(shell grep "refs/tags/LA.QSSI" .repo/manifests/default.xml | cut -d '"' -f2 | cut -d "/" -f3) \
    ro.qcom.vendor=$(shell grep "refs/tags/LA.VENDOR" .repo/manifests/default.xml | cut -d '"' -f2 | cut -d "/" -f3) 

#   ro.qcom.system=$(shell grep "refs/tags/android-13.0" .repo/manifests/default.xml | cut -d '"' -f2 | cut -d "/" -f3) \
#   ro.qcom.vendor=LA.UM.9.14.r1-19600.01-LAHAINA.QSSI12.0

# Build fingerprint
ifneq ($(BUILD_FINGERPRINT),)
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)
endif

ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.build.stock_fingerprint=$(PRODUCT_OVERRIDE_FINGERPRINT)

XPE_DISPLAY_VERSION := $(XPE_VERSION)

# Gaussian Blur
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.sf.blurs_are_expensive=1 \
    ro.surface_flinger.supports_background_blur=1

ifeq ($(XPERIENCE_CHANNEL),OFFICIAL)
# Signing
-include vendor/xperience/signing/keys.mk
endif
