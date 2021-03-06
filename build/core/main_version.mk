# Apply it to build.prop
ADDITIONAL_BUILD_PROPERTIES += \
    ro.xpe.version=$(XPE_VERSION) \
    ro.xpe.releasetype=$(XPE_BUILDTYPE) \
    ro.xperience.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.xpe.channeltype=$(XPERIENCE_CHANNEL) \
    ro.modversion=$(XPE_VERSION) \
    ro.xpe.model=$(XPERIENCE_BUILD) \
    ro.xpe.codename=Draugr \
    ro.xpelegal.url=http://thexperienceproject.org/legal/ \
    ro.boot.vendor.overlay.theme=com.android.internal.systemui.navbar.gestural

ADDITIONAL_BUILD_PROPERTIES += \
   ro.qcom.system=$(shell grep "refs/tags/LA.QSSI" .repo/manifests/snippets/caf.xml | cut -d '"' -f2 | cut -d "/" -f3) \
   ro.qcom.vendor=$(shell grep "refs/tags/LA.UM" .repo/manifests/snippets/caf.xml | cut -d '"' -f2 | cut -d "/" -f3) 

# Build fingerprint
ifneq ($(BUILD_FINGERPRINT),)
ADDITIONAL_BUILD_PROPERTIES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)
endif

XPE_DISPLAY_VERSION := $(XPE_VERSION)

# Gaussian Blur
ADDITIONAL_BUILD_PROPERTIES += \
    ro.sf.blurs_are_expensive=1 \
    ro.surface_flinger.supports_background_blur=1
