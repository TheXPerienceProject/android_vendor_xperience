# XPerience System Properties
ADDITIONAL_BUILD_PROPERTIES += \
    ro.xpe.version=$(XPE_VERSION) \
    ro.xpe.releasetype=$(XPE_BUILDTYPE) \
    ro.xperience.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.xpe.channeltype=$(XPERIENCE_CHANNEL) \
    ro.modversion=$(XPE_VERSION) \
    ro.xpe.model=$(XPERIENCE_BUILD) \
    ro.xpe.codename=Red-Velvet-Cake \
    ro.xpelegal.url=http://klozz.github.io/TheXPerienceProject/legal/ \
    ro.boot.vendor.overlay.theme=com.android.internal.systemui.navbar.gestural

# Build fingerprint
ifneq ($(BUILD_FINGERPRINT),)
ADDITIONAL_BUILD_PROPERTIES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)
endif

XPE_DISPLAY_VERSION := $(XPE_VERSION)

#Now called vendor branch
SYSTEM_CAF_BRANCH := LA.QSSI.11.0.r1-06500-qssi.0
VENDOR_CAF_BRANCH := LA.UM.9.1.r1-06700-SMxxx0.0

ADDITIONAL_BUILD_PROPERTIES += \
    ro.xpe.display.version=$(XPE_DISPLAY_VERSION)

ADDITIONAL_BUILD_PROPERTIES += \
    persist.backup.ntpServer=0.pool.ntp.org \
    sys.vendor.shutdown.waittime=500

ADDITIONAL_BUILD_PROPERTIES += \
    ro.build.version.system.qcom=$(VENDOR_CAF_BRANCH) \
    ro.build.version.vendor.qcom=$(SYSTEM_CAF_BRANCH)

# Gaussian Blur
ADDITIONAL_BUILD_PROPERTIES += \
    ro.sf.blurs_are_expensive=1 \
    ro.surface_flinger.supports_background_blur=1
