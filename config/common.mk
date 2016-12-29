RODUCT_BRAND ?= XPerience & MXSeñorPato

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ "$(TARGET_SCREEN_WIDTH)" -lt "$(TARGET_SCREEN_HEIGHT)" ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,,$(shell ls -1 vendor/XPe/prebuilt/common/bootanimation | sort -rn))

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then \
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
    ro.config.ringtone=Triton.ogg \
    ro.config.notification_sound=pixiedust.ogg \
    ro.config.alarm_alert=Osmium.ogg
    
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.opa.elegible_device=true

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Default notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.notification_sound=Chime.ogg \
    ro.config.alarm_alert=Flow.ogg

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0
endif

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

ifneq ($(XPE_BUILDTYPE),RELEASE)
# PRODUCT_COPY_FILES += \
#     vendor/XPe/CHANGELOG.mkdn:system/etc/CHANGELOG-XPE.txt
endif

# Copy over the changelog to the device
PRODUCT_COPY_FILES += \
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

ifeq ($(XPE_BUILD), ghost)
PRODUCT_COPY_FILES += \
    vendor/XPe/prebuilt/common/etc/init.d/02XPerienceColorcalib:system/etc/init.d/02XPerienceColorcalib
endif

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/XPe/config/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/XPe/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# init.d spport
PRODUCT_COPY_FILES += \
    vendor/XPe/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/XPe/prebuilt/common/bin/sysinit:system/bin/sysinit

# SuperSU
ifeq ($(WITH_SUPERSU),true)
PRODUCT_COPY_FILES += \
    vendor/XPe/prebuilt/common/UPDATE-SuperSU.zip:system/addon.d/UPDATE-SuperSU.zip \
    vendor/XPe/prebuilt/common/etc/init.d/99SuperSUDaemon:system/etc/init.d/99SuperSUDaemon
endif

ifneq ($(TARGET_BUILD_VARIANT),user)
# userinit support
PRODUCT_COPY_FILES += \
    vendor/XPe/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit
endif

# specific init file
PRODUCT_COPY_FILES += \
    vendor/XPe/prebuilt/common/etc/init.local.rc:root/init.xpe.rc


# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/XPe/prebuilt/common/lib/content-types.properties:system/lib/content-types.properties

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# This is XPe!
PRODUCT_COPY_FILES += \
    vendor/XPe/config/permissions/mx.xperience.android.xml:system/etc/permissions/mx.xperience.android.xml

#Pixel <3
PRODUCT_COPY_FILES += \
    vendor/XPe/prebuilt/NexusLauncher/NexusLauncher.apk:system/priv-app/NexusLauncher/NexusLauncher.apk \
    vendor/XPe/prebuilt/WallpaperGoogle/WallpaperGoogle.apk:system/priv-app/WallpaperGoogle/WallpaperGoogle.apk

#Performance App
PRODUCT_COPY_FILES += \
    vendor/XPe/prebuilt/common/app/XPerienceAlessav2.apk:system/app/XPeriencePerformance/XPeriencePerformance.apk

#XPerience Display
PRODUCT_COPY_FILES += \
    vendor/XPe/prebuilt/common/app/XPeDisplay.apk:system/app/XPeDisplay/XPeDisplay.apk

#7z 16
PRODUCT_COPY_FILES += \
    vendor/XPe/7z/system/lib/lib7z.so:system/lib/lib7z.so \
    vendor/XPe/7z/system/xbin/7z:system/xbin/7z

# Include XPe audio files
include vendor/XPe/config/xpe_audio.mk

# Theme engine
-include vendor/XPe/config/themes_common.mk

ifneq ($(TARGET_DISABLE_CMSDK), true)
# CMSDK
include vendor/XPe/config/cmsdk_common.mk
endif

#XPerience Services
PRODUCT_PACKAGES += xpe-services
PRODUCT_PACKAGES += mx.xperience.power.ShutdownXPe.xml
PRODUCT_BOOT_JARS += xpe-services

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
    LiveWallpapersPicker \
    PhotoTable \
    Terminal

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# Custom packages
PRODUCT_PACKAGES += \
    AudioFX \
    CMFileManager \
    CMSettingsProvider \
    CMWallpapers \
    Eleven \
    ExactCalculator \
    XPe_Browser \
    LiveLockScreenService \
    LockClock \
    masquerade \
    NexusLauncher \
    Trebuchet \
    WallpaperPicker \
    WeatherProvider \
    WallpaperGoogle \
    XPeUpdater \
    XPerienceSetupWizard

# Exchange support
PRODUCT_PACKAGES += \
    Exchange2

# Extra tools
PRODUCT_PACKAGES += \
    bash \
    bzip2 \
    curl \
    fsck.ntfs \
    gdbserver \
    htop \
    libsepol \
    micro_bench \
    mke2fs \
    mkfs.ntfs \
    mount.ntfs \
    oprofiled \
    pigz \
    powertop \
    sqlite3 \
    strace \
    tune2fs \
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

# Storage manager
PRODUCT_PROPERTY_OVERRIDES += \
    ro.storage_manager.enabled=true

# Telephony
PRODUCT_PACKAGES += \
    telephony-ext

PRODUCT_BOOT_JARS += \
    telephony-ext

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    procmem \
    procrank

# Conditionally build in su
PRODUCT_PACKAGES += \
    su
endif

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=0

DEVICE_PACKAGE_OVERLAYS += vendor/XPe/overlay/common

PRODUCT_VERSION_MAJOR = 11
PRODUCT_VERSION_MINOR = 1
PRODUCT_VERSION_MAINTENANCE = 1


-include vendor/XPe/xperienced.mk

PRODUCT_PACKAGE_OVERLAYS += vendor/XPe/overlay/common

# Set XPE_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat

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

ifeq ($(XPE_BUILDTYPE), UNOFFICIAL)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        XPE_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

ifeq ($(XPE_BUILDTYPE), RELEASE)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
        XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(XPE_BUILD)
    else
        ifeq ($(TARGET_BUILD_VARIANT),user)
#            ifeq ($(XPE_VERSION_MAINTENANCE),0)
                XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(XPE_BUILD)
#            else
#                XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(XPE_BUILD)
#            endif
        else
            XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(XPE_BUILD)
        endif
    endif
else
#    ifeq ($(XPE_VERSION_MAINTENANCE),0)
#        XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d)-$(XPE_BUILDTYPE)$(XPE_EXTRAVERSION)-$(XPE_BUILD)
#    else
        XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(shell date -u +%Y%m%d)-$(XPE_BUILDTYPE)$(XPE_EXTRAVERSION)-$(XPE_BUILD)
#    endif
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.xpe.version=$(XPE_VERSION) \
    ro.xpe.releasetype=$(XPE_BUILDTYPE) \
    ro.modversion=$(XPE_VERSION) \
    ro.xpe.model=$(XPE_BUILD) \
    ro.xpe.codename=Kukulkán \
    ro.xpelegal.url=http://thexperienceproject.com/legal/

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
            XPE_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)
     endif
endif
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.xpe.display.version=$(XPE_DISPLAY_VERSION)

-include $(WORKSPACE)/build_env/image-auto-bits.mk

-include vendor/cyngn/product.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)
