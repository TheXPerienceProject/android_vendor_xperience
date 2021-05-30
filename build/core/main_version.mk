# Apply it to build.prop
ADDITIONAL_BUILD_PROPERTIES += \
    ro.xpe.version=$(XPE_VERSION) \
    ro.xpe.releasetype=$(XPE_BUILDTYPE) \
    ro.xperience.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.xpe.channeltype=$(XPERIENCE_CHANNEL) \
    ro.modversion=$(XPE_VERSION) \
    ro.xpe.model=$(XPERIENCE_BUILD) \
    ro.xpe.codename=Red-Velvet-Cake \
    ro.xpelegal.url=http://thexperienceproject.org/legal/ \
    ro.boot.vendor.overlay.theme=com.android.internal.systemui.navbar.gestural

#Now called vendor branch
SYSTEM_CAF_BRANCH := $(shell grep "refs/tags/LA.QSSI" .repo/manifests/default.xml | cut -d '"' -f2 | cut -d "/" -f3)
VENDOR_CAF_BRANCH := $(shell grep "refs/tags/LA.UM" .repo/manifests/default.xml | cut -d '"' -f2 | cut -d "/" -f3)

ADDITIONAL_BUILD_PROPERTIES += \
    ro.build.version.system.qcom=$(VENDOR_CAF_BRANCH) \
    ro.build.version.vendor.qcom=$(SYSTEM_CAF_BRANCH)

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
