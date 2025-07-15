PRODUCT_BRAND ?= XPerience
# Versioning
-include vendor/xperience/config/version.mk

# Include Common Qualcomm Device Tree.
$(call inherit-product, device/xperience/common/common.mk)

# Implementation of lineage HEALTH
# HIDL
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    vendor/xperience/interfaces/vendor_framework_compatibility_matrix.xml

TARGET_DISABLE_SHUTDOWNANIMATION ?= true

TARGET_SCREEN_WIDTH ?= 1080
TARGET_BOOT_ANIMATION_SIZE ?= $(TARGET_SCREEN_WIDTH)

PRODUCT_BOOTANIMATION := vendor/xperience/prebuilt/bootanimation/$(TARGET_BOOT_ANIMATION_SIZE).zip

ifeq ($(TARGET_IS_LOW_RAM),true)
PRODUCT_BOOTANIMATION := vendor/xperience/prebuilt/bootanimation/1080-lowram.zip
endif

ifeq ($(TARGET_HAS_OLD_BOOTANIM), true)
PRODUCT_BOOTANIMATION := vendor/xperience/prebuilt/bootanimation/1080-old.zip
endif

#We aren't using this old form anymore so for now i will use all other info with copy file then i will change it
$(warning bootanimation from $(PRODUCT_BOOTANIMATION))
$(warning XPERIENCE_BUILD is $(XPERIENCE_BUILD))

PRODUCT_COPY_FILES += \
    $(PRODUCT_BOOTANIMATION):$(TARGET_COPY_OUT_SYSTEM)/media/bootanimation.zip

ifneq ($(TARGET_DISABLE_SHUTDOWNANIMATION), true)
$(warning Enabled shutdown animation)
PRODUCT_COPY_FILES += \
    vendor/xperience_shutdown/shutdownanimation.zip:$(TARGET_COPY_OUT_SYSTEM)/media/shutdownanimation.zip
else
    $(warning Disabled shutdown animation)
endif

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# Fixes: terminate called after throwing an instance of 'std::out_of_range' what(): basic_string::erase
# error with prop override
#PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

# general properties
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    setupwizard.enable_assist_gesture_training=true

PRODUCT_PRODUCT_PROPERTIES += \
    ro.config.ringtone=Rasalas.ogg \
    ro.config.notification_sound=Notification_H.ogg \
    ro.config.alarm_alert=Xperia_alarm.ogg

# IORap app launch prefetching using Perfetto traces and madvise
PRODUCT_PRODUCT_PROPERTIES += \
    ro.iorapd.enable=true

# EGL - Blobcache configuration
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.egl.blobcache.multifile=true \
    ro.egl.blobcache.multifile_limit=33554432

# Enable Material Design 3 Expressive
PRODUCT_PRODUCT_PROPERTIES += \
    is_expressive_design_enabled=true

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Disable extra StrictMode features on all non-engineering builds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.strictmode.disable=true
endif

# Enable support of one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode=true

# PRODUCT_BROKEN_VERIFY_USES_LIBRARIES := true
BUILD_BROKEN_MISSING_REQUIRED_MODULES := true

# Enable SIP and VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.sip.voip.xml

# Charging sounds
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/media/audio/notifications/BatteryPlugged_48k.ogg:$(TARGET_COPY_OUT_SYSTEM)/media/audio/ui/BatteryPlugged_48k.ogg

# XPerience permissions
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/etc/permissions/org.lineageos.health.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/org.lineageos.health.xml

# Credential storage
PRODUCT_PACKAGES += \
    android.software.credentials.prebuilt.xml

# Charger
#PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.charger.enable_suspend=1

# Face Unlock with paranoidsense
PRODUCT_PACKAGES += \
    ParanoidSense

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml

# Enable Sense service for 64-bit only
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.face.sense_service=$(TARGET_SUPPORTS_64_BIT_APPS)

# Disable remote keyguard animation
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.wm.enable_remote_keyguard_animation=0

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=log

# Additional packages
-include vendor/xperience/config/packages.mk

# GSM porque si
-include vendor/xperience/config/gsm.mk

# Themes and Theme overlays
#include vendor/themes/themes.mk

# Add our overlays
DEVICE_PACKAGE_OVERLAYS += vendor/xperience/overlay/common

# Exclude from RRO
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/xperience/overlay

PRODUCT_PACKAGES += \
    DocumentsUIOverlay \
    NetworkStackOverlay

# Include CM LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/xperience/overlay/dictionaries

# Squisher Location
SQUISHER_SCRIPT := vendor/xperience/tools/squisher

# Snapdragon Clang
#$(call inherit-product, vendor/qcom/sdclang/config/SnapdragonClang.mk)

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

TARGET_DISABLE_EPPE ?= false
$(warning TARGET_DISABLE_EPPE is $(TARGET_DISABLE_EPPE))
ifneq ($(TARGET_DISABLE_EPPE),true)
$(warning EPPE is enforced! )
# Require all requested packages to exist
$(call enforce-product-packages-exist-internal,$(wildcard device/*/$(XPERIENCE_BUILD)/$(TARGET_PRODUCT).mk),product_manifest.xml rild Calendar Launcher3 Launcher3Go Launcher3QuickStep Launcher3QuickStepGo android.hidl.memory@1.0-impl.vendor vndk_apex_snapshot_package)
else
$(warning EPPE is disabled! )
endif

# Copy all xperience-specific init rc files
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/etc/init/xperience-system_ext.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.xperience-system_ext.rc \
    vendor/xperience/prebuilt/etc/init/xperience-ssh.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/int.xperience.openssh.rc \
    vendor/xperience/prebuilt/etc/init/xperience-updates.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.xperience-updater.rc

# Optimize everything for preopt
# PRODUCT_DEX_PREOPT_DEFAULT_COMPILER_FILTER := everything
PRODUCT_DEX_PREOPT_DEFAULT_COMPILER_FILTER := speed-profile

# Compile SystemUI on device with `speed`.
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.systemservercompilerfilter=speed \
    dalvik.vm.systemuicompilerfilter=speed

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Enable whole-program R8 Java optimizations for SystemUI and system_server
SYSTEM_OPTIMIZE_JAVA := true
SYSTEMUI_OPTIMIZE_JAVA := true

# EGL - Blobcache configuration
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.egl.blobcache.multifile=true \
    ro.egl.blobcache.multifile_limit=33554432

# Set default refresh rate threshold
# Display
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    debug.sf.frame_rate_multiple_threshold=60 \
    ro.surface_flinger.enable_frame_rate_override=false


# Rescue Party
# Disable RescueParty due to high risk of data loss
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.disable_rescue=true

# Apply it to build.prop
PRODUCT_PRODUCT_PROPERTIES += \
    ro.xpe.version=$(XPE_VERSION) \
    ro.xpe.releasetype=$(XPE_BUILDTYPE) \
    ro.xperience.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.xperience.build.version2=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(BUILD_DATE)-$(XPE_BUILDTYPE)-$(XPERIENCE_BUILD) \
    ro.xpe.version.minor=$(PRODUCT_VERSION_MAJOR) \
    ro.xpe.version.major=$(PRODUCT_VERSION_MINOR) \
    ro.xpe.channeltype=$(XPERIENCE_CHANNEL) \
    ro.modversion=$(XPE_VERSION) \
    ro.xpe.model=$(XPERIENCE_BUILD) \
    ro.xpe.device=$(XPERIENCE_BUILD) \
    ro.xpe.codename=Boro \
    ro.xpelegal.url=http://thexperienceproject.klozz.dev/legal/ \
    ro.boot.vendor.overlay.theme=com.android.internal.systemui.navbar.gestural

PRODUCT_CFI_EXCLUDE_PATHS += \
    external/wpa_supplicant_8/wpa_supplicant \
    external/wpa_supplicant_8/hostapd

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ota.allow_downgrade=true

# System
persist.sys.binary_xml=false

# Disable default frame rate limit for games
PRODUCT_PRODUCT_PROPERTIES += \
    debug.graphics.game_default_frame_rate.disabled=true

PRODUCT_PACKAGES += \
    nano_recovery \
    htop \
    ncurses

# TFLite service.
PRODUCT_PACKAGES += libtensorflowlite_jni

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/lib/libtensorflowlite_jni.so \
    system/lib64/libtensorflowlite_jni.so

# Disable async MTE on a few processes
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.arm64.memtag.app.com.android.se=off \
    persist.arm64.memtag.app.com.google.android.bluetooth=off \
    persist.arm64.memtag.app.com.android.nfc=off \
    persist.arm64.memtag.process.system_server=off

# sony extra features
$(call inherit-product-if-exist, vendor/sony/extra/extra.mk)

# Performance tuning per SoC
ifneq ($(filter pineapple volcano,$(TARGET_BOARD_PLATFORM)),)
  $(warning "Perf tuning for LANAI platform.")
PRODUCT_PRODUCT_PROPERTIES += \
    dalvik.vm.dex2oat-cpu-set=0,1,2,3,4,5,6,7 \
    dalvik.vm.dex2oat-threads=8 \
    dalvik.vm.image-dex2oat-threads=8 \
    dalvik.vm.dex2oat-filter=speed \
    dalvik.vm.dex2oat64.enabled=true \
    pm.dexopt.bg-dexopt=everything \
    pm.dexopt.first-boot=speed \
    pm.dexopt.boot=speed-profile \
    pm.dexopt.install=speed-profile

# Snapdragon 8 Elite (SM8750) — codename sun
else ifneq ($(filter sun,$(TARGET_BOARD_PLATFORM)),)
  $(warning "Perf tuning for SUN (Snapdragon 8 Elite / SM8750).")
PRODUCT_PRODUCT_PROPERTIES += \
    dalvik.vm.dex2oat-cpu-set=0,1,2,3,4,5,6,7,8,9 \
    dalvik.vm.dex2oat-threads=10 \
    dalvik.vm.image-dex2oat-threads=10 \
    dalvik.vm.dex2oat64.enabled=true \
    dalvik.vm.dex2oat-filter=speed \
    pm.dexopt.bg-dexopt=everything \
    pm.dexopt.first-boot=speed \
    pm.dexopt.boot=speed-profile \
    pm.dexopt.install=speed-profile

else ifneq ($(filter kailua,$(TARGET_BOARD_PLATFORM)),)
  $(warning "Perf tuning for KAILUA platform.")
PRODUCT_PRODUCT_PROPERTIES += \
    dalvik.vm.dex2oat-cpu-set=0,1,2,3,4,5,6 \
    dalvik.vm.dex2oat-threads=6 \
    dalvik.vm.image-dex2oat-threads=6 \
    dalvik.vm.dex2oat-filter=speed \
    dalvik.vm.dex2oat64.enabled=true \
    pm.dexopt.bg-dexopt=everything \
    pm.dexopt.first-boot=speed \
    pm.dexopt.boot=speed-profile \
    pm.dexopt.install=speed-profile

else ifneq ($(filter lahaina,$(TARGET_BOARD_PLATFORM)),)
  $(warning "Perf tuning for LAHAINA platform.")
PRODUCT_PRODUCT_PROPERTIES += \
    dalvik.vm.dex2oat-cpu-set=0,1,2,3,4 \
    dalvik.vm.dex2oat-threads=4 \
    dalvik.vm.image-dex2oat-threads=4 \
    dalvik.vm.dex2oat64.enabled=true \
    dalvik.vm.dex2oat-filter=speed \
    pm.dexopt.bg-dexopt=everything \
    pm.dexopt.first-boot=speed \
    pm.dexopt.boot=speed-profile \
    pm.dexopt.install=speed-profile
endif

# PIF values
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.pihooks_MANUFACTURER?=Google \
    persist.sys.pihooks_BRAND?=google \
    persist.sys.pihooks_PRODUCT?=panther_beta \
    persist.sys.pihooks_DEVICE?=panther \
    persist.sys.pihooks_ID?=BP31.250523.010 \
    persist.sys.pihooks_RELEASE?=12 \
    persist.sys.pihooks_SECURITY_PATCH?=2025-06-05 \
    persist.sys.pihooks_DEVICE_INITIAL_SDK_INT?=21 \
    persist.sys.pihooks_SDK_INT?=32

PRODUCT_BUILD_PROP_OVERRIDES += \
    PihooksGmsFp="google/panther_beta/panther:16/BP31.250523.010/13667654:user/release-keys" \
    PihooksGmsModel="Pixel 7"