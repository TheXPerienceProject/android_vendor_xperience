# XPerience System Properties
ADDITIONAL_BUILD_PROPERTIES += \
    ro.xpe.version=$(XPE_VERSION) \
    ro.xpe.releasetype=$(XPE_BUILDTYPE) \
    ro.xperience.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.xpe.channeltype=$(XPERIENCE_CHANNEL) \
    ro.modversion=$(XPE_VERSION) \
    ro.xpe.model=$(XPE_BUILD) \
    ro.xpe.codename=Rossweisse-(ロスヴァイセ) \
    ro.xpe.cafbranch=LA.UM.7.3.r1-06700-sdm845.0 \
    ro.xpelegal.url=http://thexperienceproject.com/legal/

XPE_DISPLAY_VERSION := $(XPE_VERSION)

CAF_BRANCH := $(ro.xpe.cafbranch)

ADDITIONAL_BUILD_PROPERTIES += \
    ro.xpe.display.version=$(XPE_DISPLAY_VERSION)

ADDITIONAL_BUILD_PROPERTIES += \
    persist.backup.ntpServer=0.pool.ntp.org \
    sys.vendor.shutdown.waittime=500

#Call perf blobs
include vendor/xperience/xperience-performance/common-perf/perf-common.mk

PRODUCT_PACKAGES += QPerformance UxPerformance
PRODUCT_BOOT_JARS += QPerformance UxPerformance

ADDITIONAL_BUILD_PROPERTIES += \
    ro.vendor.extension_library=libqti-perfd-client.so \
    vendor.enable_prefetch=1 \
    vendor.iop.enable_uxe=1 \
    vendor.iop.enable_prefetch_ofr=1 \
    vendor.perf.iop_v3.enable=1 \
    ro.vendor.at_library=libqti-at.so \
    persist.vendor.qti.games.gt.prof=1 \
    ro.build.version.qcom=$(CAF_BRANCH)
