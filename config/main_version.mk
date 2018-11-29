# XPerience System Properties
ADDITIONAL_BUILD_PROPERTIES += \
    ro.xpe.version=$(XPE_VERSION) \
    ro.xpe.releasetype=$(XPE_BUILDTYPE) \
    ro.xperience.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.xpe.channeltype=$(XPERIENCE_CHANNEL) \
    ro.modversion=$(XPE_VERSION) \
    ro.xpe.model=$(XPE_BUILD) \
    ro.xpe.codename=Rossweisse-(ロスヴァイセ) \
    ro.xpe.cafbranch=LA.UM.7.2.r1-05400-sdm660.0 \
    ro.xpelegal.url=http://thexperienceproject.com/legal/

XPE_DISPLAY_VERSION := $(XPE_VERSION)

CAF_BRANCH := LA.UM.7.2.r1-05400-sdm660.0

ADDITIONAL_BUILD_PROPERTIES += \
    ro.xpe.display.version=$(XPE_DISPLAY_VERSION)

#Call perf blobs
include vendor/xperience/xperience-performance/common-perf/perf-common.mk


ADDITIONAL_BUILD_PROPERTIES += \
    ro.vendor.extension_library=libqti-perfd-client.so \
    ro.build.version.qcom=$(CAF_BRANCH)
