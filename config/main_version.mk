# XPerience System Properties
ADDITIONAL_BUILD_PROPERTIES += \
    ro.xpe.version=$(XPE_VERSION) \
    ro.xpe.releasetype=$(XPE_BUILDTYPE) \
    ro.xperience.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.xpe.channeltype=$(XPERIENCE_CHANNEL) \
    ro.modversion=$(XPE_VERSION) \
    ro.xpe.model=$(XPE_BUILD) \
    ro.xpe.codename=Tanabata \
    ro.xpe.cafbranch=LA.UM.6.6.r1-09000-89xx.0 \
    ro.xpelegal.url=http://thexperienceproject.com/legal/

XPE_DISPLAY_VERSION := $(XPE_VERSION)

ADDITIONAL_BUILD_PROPERTIES += \
    ro.xpe.display.version=$(XPE_DISPLAY_VERSION)
