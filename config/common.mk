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
bootanimation_sizes := $(subst .zip,,$(shell ls -1 vendor/xperience/prebuilt/common/bootanimation | sort -rn))

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

PRODUCT_BOOTANIMATION := vendor/xperience/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
endif

#well I add ringtones here for all devices
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.config.ringtone=XPerienceRing.ogg,XPerienceRing.ogg \
    ro.config.notification_sound=Reminder.ogg \
    ro.config.alarm_alert=Fuego.ogg

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    keyguard.no_require_sim=true \
    ro.opa.elegible_device=true

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.build.selinux=1

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.dun.override=0
endif

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Disable Rescue Party
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.sys.disable_rescue=true

# Copy over the changelog to the device
PRODUCT_COPY_FILES += \
    vendor/xperience/DONATORS.mkdn:system/etc/donators.txt

# Lower RAM devices
ifeq ($(XPE_LOW_RAM_DEVICE),true)
TARGET_BOOTANIMATION_TEXTURE_CACHE := false
TARGET_HAS_LOW_RAM := true

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    config.disable_atlas=true \
    dalvik.vm.jit.codecachesize=0 \
    persist.sys.force_highendgfx=true \
    ro.config.low_ram=true \
    ro.config.max_starting_bg=8 \
    ro.sys.fw.bg_apps_limit=16
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/xperience/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/xperience/prebuilt/common/bin/50-xpe.sh:system/addon.d/50-xpe.sh \
    vendor/xperience/prebuilt/common/bin/blacklist:system/addon.d/blacklist

# Clean up packages cache to avoid wrong strings and resources
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/bin/clean_cache.sh:system/bin/clean_cache.sh

# Fonts
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/common/fonts/GoogleSans-Regular.ttf:system/fonts/GoogleSans-Regular.ttf \
    vendor/xperience/prebuilt/common/fonts/GoogleSans-Medium.ttf:system/fonts/GoogleSans-Medium.ttf \
    vendor/xperience/prebuilt/common/fonts/GoogleSans-MediumItalic.ttf:system/fonts/GoogleSans-MediumItalic.ttf \
    vendor/xperience/prebuilt/common/fonts/GoogleSans-Italic.ttf:system/fonts/GoogleSans-Italic.ttf \
    vendor/xperience/prebuilt/common/fonts/GoogleSans-Bold.ttf:system/fonts/GoogleSans-Bold.ttf \
    vendor/xperience/prebuilt/common/fonts/GoogleSans-BoldItalic.ttf:system/fonts/GoogleSans-BoldItalic.ttf

#Falcon Tweaking
ifeq ($(XPE_BUILD), falcon)
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/common/etc/init.d/01XPerienceKernelCOnf:system/etc/init.d/01XPerienceKernelCOnf
endif

ifeq ($(XPE_BUILD), ghost)
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/common/etc/init.d/02XPerienceColorcalib:system/etc/init.d/02XPerienceColorcalib
endif

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/xperience/config/permissions/backup.xml:system/etc/sysconfig/backup.xml

# init.d support
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/xperience/prebuilt/common/bin/sysinit:system/bin/sysinit

ifneq ($(TARGET_BUILD_VARIANT),user)
# userinit support
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit
endif

# Copy all xperience-specific init rc files
$(foreach f,$(wildcard vendor/xperience/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):system/etc/init/$(notdir $f)))

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/common/lib/content-types.properties:system/lib/content-types.properties

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# This is xperience!
PRODUCT_COPY_FILES += \
    vendor/xperience/config/permissions/mx.xperience.android.xml:system/etc/permissions/mx.xperience.android.xml \
    vendor/xperience/config/permissions/privapp-permissions-xperience.xml:system/etc/permissions/privapp-permissions-xperience.xml

#7z 16
PRODUCT_COPY_FILES += \
    vendor/xperience/7z/system/lib/lib7z.so:system/lib/lib7z.so \
    vendor/xperience/7z/system/xbin/7z:system/xbin/7z

# Include xperience audio files
include vendor/xperience/config/xpe_audio.mk

# Use signing keys for only official builds
ifeq ($(XPERIENCE_CHANNEL),OFFICIAL)
    PRODUCT_DEFAULT_DEV_CERTIFICATE := .keys/releasekey
    PRODUCT_OTA_PUBLIC_KEYS = .keys/releasekey/otakey.x509.pem

# Only build OTA if official
PRODUCT_PACKAGES += \
    Updater

endif

#XPerience colour :v well not is from xpe but It will be added here so..
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.ime.theme_id=4

# Themes
$(call inherit-product-if-exists, vendor/xperience/config/themes/themes.mk)

#XPerience Services
#PRODUCT_PACKAGES += xpe-services
#PRODUCT_PACKAGES += mx.xperience.power.ShutdownXPe.xml
#PRODUCT_BOOT_JARS += xpe-services

PRODUCT_PACKAGES += QPerformance UxPerformance
PRODUCT_BOOT_JARS += QPerformance UxPerformance

# TWRP
ifeq ($(WITH_TWRP),true)
include vendor/xperience/config/twrp.mk
endif

# Include AmbientSense if it's available
-include vendor/ambientmusic/AmbientMusic.mk

# Required XPe packages
PRODUCT_PACKAGES += \
    BluetoothExt \
    Development \
    Profiles \
    DownloadProvider \
    MediaProvider

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
    Alessa \
    AmbientPlayHistoryProvider \
    CommandCenter3 \
    ExactCalculator \
    LockClock \
    Notes \
    SubstratumSignature \
    WeatherClient \
    XPeriaHome \
    XPeriaWeather \
    XPerienceWallpapers \
    Yunikon

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
ifneq ($(WITH_XPE_CHARGER),false)
PRODUCT_PACKAGES += \
    charger_res_images \
    xpe_charger_res_images \
    font_log.png \
    libhealthd.xpe
endif

ifeq ($(BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE),)
  PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.device.cache_dir=/data/cache
else
  PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.device.cache_dir=/cache
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

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    procmem \
    procrank

# Conditionally build in su
#PRODUCT_PACKAGES += \
#    su
endif

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.sys.root_access=0

DEVICE_PACKAGE_OVERLAYS += \
    vendor/xperience/overlay/common

PRODUCT_VERSION_MAJOR = 13
PRODUCT_VERSION_MINOR = 0
PRODUCT_VERSION_MAINTENANCE = 0
PRODUCT_EXPERIMENTAL = 0

ifndef XPERIENCE_CHANNEL
    XPERIENCE_CHANNEL := UNOFFICIAL
endif

-include vendor/xperience/xperienced.mk

###########################################################################
# Set XPE_BUILDTYPE from the env RELEASE_TYPE
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
ifeq ($(filter RELEASE NIGHTLY HOMECASE WEEKLY SNAPSHOT EXPERIMENTAL STABLERELEASE,$(XPE_BUILDTYPE)),)
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
ifeq ($(PRODUCT_EXPERIMENTAL),1)
    XPE_BUILDTYPE := EXPERIMENTAL
    XPE_EXTRAVERSION :=
else
    XPE_BUILDTYPE := HOMECASE
    XPE_EXTRAVERSION :=
endif
endif

ifeq ($(XPE_BUILDTYPE), UNOFFICIAL HOMECASE)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        XPE_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

ifeq ($(XPE_BUILDTYPE), RELEASE)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
        XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(shell date -u +%Y%m%d)-$(XPE_BUILDTYPE)-$(XPE_BUILD)
    else
        ifeq ($(TARGET_BUILD_VARIANT),user)
            ifeq ($(XPE_VERSION_MAINTENANCE),0)
                XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(XPE_BUILD)
            else
                XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(XPE_BUILD)
            endif
        else
            XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(XPE_BUILD)
        endif
    endif
else
    ifeq ($(XPE_VERSION_MAINTENANCE),0)
        XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(shell date -u +%Y%m%d)-$(XPE_BUILDTYPE)$(XPE_EXTRAVERSION)-$(XPE_BUILD)
    else
        XPE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(shell date -u +%Y%m%d)-$(XPE_BUILDTYPE)$(XPE_EXTRAVERSION)-$(XPE_BUILD)
    endif
endif

###########################################################################
-include vendor/XPe-priv/keys/keys.mk

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
            XPE_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(TARGET_VENDOR_RELEASE_BUILD_ID)
     endif
endif
endif

-include $(WORKSPACE)/build_env/image-auto-bits.mk
