PRODUCT_BRAND ?= XPerience & MXSeñorPato

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ "$(TARGET_SCREEN_WIDTH)" -lt "$(TARGET_SCREEN_HEIGHT)" ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/XPe/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ "$(1)" -le "$(TARGET_BOOTANIMATION_SIZE)" ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

PRODUCT_BOOTANIMATION := vendor/XPe/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
endif

#well I add ringtones here for all devices
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.ringtone=BeatPlucker.ogg \
    ro.config.notification_sound=Tethys.ogg \
    ro.config.alarm_alert=Osmium.ogg
    
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.com.google.clientidbase=android-google \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Default notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Helium.ogg

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0
endif

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Copy over the changelog to the device
PRODUCT_COPY_FILES += \
    vendor/XPe/CHANGELOG.mkdn:system/etc/CHANGELOG-XPE.txt \
    vendor/XPe/DONATORS.mkdn:system/etc/donators.txt

# Lower RAM devices
ifeq ($(XPE_LOW_RAM_DEVICE),true)
MALLOC_IMPL := dlmalloc
TARGET_BOOTANIMATION_TEXTURE_CACHE := false

PRODUCT_PROPERTY_OVERRIDES += \
    config.disable_atlas=true \
    dalvik.vm.jit.codecachesize=0 \
    persist.sys.force_highendgfx=true \
    ro.config.low_ram=true \
    ro.config.max_starting_bg=8 \
    ro.sys.fw.bg_apps_limit=16
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/XPe/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/XPe/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/XPe/prebuilt/common/bin/50-cm.sh:system/addon.d/50-cm.sh \
    vendor/XPe/prebuilt/common/bin/blacklist:system/addon.d/blacklist


#Falcon Tweaking
ifeq ($(XPE_BUILD), falcon)
PRODUCT_COPY_FILES += \
    vendor/XPe/prebuilt/common/etc/init.d/01XPerienceKernelCOnf:system/etc/init.d/01XPerienceKernelCOnf
endif

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/XPe/config/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/XPe/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/XPe/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/XPe/prebuilt/common/bin/sysinit:system/bin/sysinit

ifneq ($(TARGET_BUILD_VARIANT),user)
# userinit support
PRODUCT_COPY_FILES += \
    vendor/XPe/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit
endif

# specific init file
PRODUCT_COPY_FILES += \
    vendor/XPe/prebuilt/common/etc/init.local.rc:root/init.xpe.rc

#Performance app
PRODUCT_COPY_FILES += \
    vendor/XPe/prebuilt/common/app/XPerienceAlessav2.apk:system/app/XPeriencePerformance/XPeriencePerformance.apk

#Fix Chromium fc workaround
#PRODUCT_COPY_FILES += \
#vendor/XPe/prebuilt/chromium/libwebviewchromium_loader.so:system/lib/libwebviewchromium_loader.so \
#vendor/XPe/prebuilt/chromium/libwebviewchromium_plat_support.so:system/lib/libwebviewchromium_plat_support.so

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/XPe/prebuilt/common/lib/content-types.properties:system/lib/content-types.properties

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# This is CM!
PRODUCT_COPY_FILES += \
    vendor/XPe/config/permissions/com.cyanogenmod.android.xml:system/etc/permissions/com.cyanogenmod.android.xml

#remember codeaurora is only for msm
#Falcon Tweaking
#ifeq ($(call is-vendor-board-platform,QCOM),true)
#PRODUCT_BOOT_JARS += \
#	org.codeaurora.Performance 
#endif

#Quickboot for user builds
ifeq ($(call is-vendor-board-platform,QCOM,motorola-qcom),true)
#ifneq ($(TARGET_BUILD_VARIANT),user)
#PRODUCT_COPY_FILES += \
#	vendor/XPe/prebuilt/common/app/user/QuickBoot.apk:system/priv-app/QuickBoot/QuickBoot.apk
#endif
#Quickboot for userdebug builds
PRODUCT_COPY_FILES += \
	vendor/XPe/prebuilt/common/app/userdebug/QuickBoot.apk:system/priv-app/QuickBoot/QuickBoot.apk
endif

#Track new themeengine and audioFX
#PRODUCT_COPY_FILES += \
#	vendor/XPe/prebuilt/common/app/AudioFX/AudioFX.apk:system/priv-app/AudioFX/AudioFX.apk \
#	vendor/XPe/config/permissions/com.cyngn.audiofx.xml:system/etc/permissions/com.cyngn.audiofx.xml \
#        vendor/XPe/prebuilt/common/bin/707-xpe.sh:system/addon.d/707-xpe.sh 

# SuperSU
#PRODUCT_COPY_FILES += \
#    vendor/XPe/prebuilt/common/UPDATE-SuperSU.zip:system/addon.d/SuperSU.zip \
#    vendor/XPe/prebuilt/common/etc/init.d/99SuperSUDaemon:system/etc/init.d/99SuperSUDaemon

# Pulsar and nexus
PRODUCT_COPY_FILES += \
    vendor/XPe/prebuilt/Pulsar/Pulsar.apk:system/app/Pulsar/Pulsar.apk \
    vendor/XPe/prebuilt/NexusLauncher/NexusLauncher.apk:system/priv-app/NexusLauncher/NexusLauncher.apk \
    vendor/XPe/prebuilt/WallpaperPicker/WallpaperPicker.apk:system/app/WallpaperPicker/WallpaperPicker.apk

# Include XPe audio files
include vendor/XPe/config/xpe_audio.mk

# Theme engine
-include vendor/XPe/config/themes_common.mk

ifneq ($(TARGET_DISABLE_CMSDK), true)
# CMSDK
include vendor/XPe/config/cmsdk_common.mk
endif

# Required CM packages
PRODUCT_PACKAGES += \
    BluetoothExt \
    CMAudioService \
    CMParts \
    Development \
    Profiles \
    WeatherManagerService

# Optional packages
PRODUCT_PACKAGES += \
    libemoji \
    Terminal \
    LiveWallpapersPicker \
    PhotoTable

# Include librsjni explicitly to workaround GMS issue
PRODUCT_PACKAGES += \
    librsjni

# Custom packages
PRODUCT_PACKAGES += \
    Launcher3 \
    Trebuchet \
    AudioFX \
    CMWallpapers \
    CMFileManager \
    Eleven \
    LockClock \
    CMSettingsProvider \
    ExactCalculator \
    LiveLockScreenService \
    WeatherProvider \
    WeatherProvider \
    SoundRecorder \
    Screencast \
    XPerienceCenter \
    XPerienceSetupWizard


# Exchange support
PRODUCT_PACKAGES += \
    Exchange2

# Extra tools
PRODUCT_PACKAGES += \
    libsepol \
    mke2fs \
    tune2fs \
    nano \
    htop \
    mkfs.ntfs \
    fsck.ntfs \
    mount.ntfs \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace \
    pigz \
    7z \
    lib7z \
    bash \
    bzip2 \
    curl \
    powertop \
    unrar \
    unzip \
    vim \
    wget \
    zip


# Custom off-mode charger
ifneq ($(WITH_CM_CHARGER),false)
PRODUCT_PACKAGES += \
    charger_res_images \
    cm_charger_res_images \
    font_log.png \
    libhealthd.cm
endif

# ExFAT support
WITH_EXFAT ?= true
ifeq ($(WITH_EXFAT),true)
TARGET_USES_EXFAT := true
PRODUCT_PACKAGES += \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat
endif

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

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    procmem \
    procrank \
    su
endif

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=0

DEVICE_PACKAGE_OVERLAYS += vendor/XPe/overlay/common

PRODUCT_VERSION_MAJOR = 11
PRODUCT_VERSION_MINOR = 0
PRODUCT_VERSION_MAINTENANCE = 0


-include vendor/XPe/xperienced.mk

PRODUCT_PACKAGE_OVERLAYS += vendor/XPe/overlay/common

# Set XPE_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat

ifndef XPE_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "XPE_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^xpe_||g')
        XPE_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# Filter out random types, so it'll reset to UNOFFICIAL
ifeq ($(filter RELEASE NIGHTLY WEEKLY SNAPSHOT EXPERIMENTAL,$(XPE_BUILDTYPE)),)
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
    XPE_BUILDTYPE := UNOFFICIAL
    XPE_EXTRAVERSION :=
   
endif

ifeq ($(XPE_BUILDTYPE), UNOFFICIAL,WEEKLY)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        XPE_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

ifeq ($(XPE_BUILDTYPE), RELEASE)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
        XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(shell date -u +%Y%m%d)-$(XPE_BUILD)
    else
        ifeq ($(TARGET_BUILD_VARIANT),user)
            XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(shell date -u +%Y%m%d)-$(XPE_BUILD)-$(XPE_BUILDTYPE)
        else
            XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(shell date -u +%Y%m%d)-$(XPE_BUILD)-$(XPE_BUILDTYPE)
        endif
    endif
else
        XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(shell date -u +%Y%m%d)$(XPE_EXTRAVERSION)-$(XPE_BUILD)-$(XPE_BUILDTYPE)

endif

PRODUCT_PROPERTY_OVERRIDES += \
  ro.xpe.version=$(XPE_VERSION) \
  ro.xpe.releasetype=$(XPE_BUILDTYPE) \
  ro.modversion=$(XPE_VERSION) \
  ro.xpe.model=$(XPE_BUILD) \
  ro.xpe.codename=Nougat \
  ro.cmlegal.url=klozz.github.io/git.klozz.personal/privacy.html

-include vendor/XPe-priv/keys/keys.mk

XPE_DISPLAY_VERSION := $(XPE_VERSION)

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
    XPE_DISPLAY_VERSION=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)
  endif
endif
endif

PRODUCT_PROPERTY_OVERRIDES += \
  ro.cm.display.version=$(XPE_DISPLAY_VERSION) \
  ro.xpe.display.version=$(XPE_DISPLAY_VERSION)

-include $(WORKSPACE)/build_env/image-auto-bits.mk

-include vendor/cyngn/product.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)

