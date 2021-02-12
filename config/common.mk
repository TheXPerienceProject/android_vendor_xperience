PRODUCT_BRAND ?= XPerience

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ "$(TARGET_SCREEN_WIDTH)" -lt "$(TARGET_SCREEN_HEIGHT)" ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

 # get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,,$(shell ls -1 vendor/xperience/prebuilt/bootanimation | sort -rn))

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

PRODUCT_BOOTANIMATION := vendor/xperience/prebuilt/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip

#We aren't using this old form anymore so for now i will use all other info with copy file then i will change it
PRODUCT_COPY_FILES += $(PRODUCT_BOOTANIMATION):$(TARGET_COPY_OUT_SYSTEM)/media/bootanimation.zip

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
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

# general properties
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.opa.eligible_device=true \
    setupwizard.theme=glif_v3_light \
    setupwizard.enable_assist_gesture_training=true \
    ro.com.google.ime.theme_id=4

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.build.selinux=1

PRODUCT_PRODUCT_PROPERTIES += \
    ro.config.ringtone=XPerienceRing.ogg \
    ro.config.notification_sound=Reminder.ogg \
    ro.config.alarm_alert=Fuego.ogg
	
# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/xperience/prebuilt/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/xperience/prebuilt/bin/50-hosts.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-hosts.sh

ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/xperience/prebuilt/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/xperience/prebuilt/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh
endif

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/etc/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.nfc.beam.xml

# Enable SIP and VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.sip.voip.xml

# Charging sounds
PRODUCT_COPY_FILES += \
    vendor/xperience/sounds/BatteryPlugged.ogg:$(TARGET_COPY_OUT_SYSTEM)/media/audio/ui/BatteryPlugged.ogg \
    vendor/xperience/sounds/BatteryPlugged_48k.ogg:$(TARGET_COPY_OUT_SYSTEM)/media/audio/ui/BatteryPlugged_48k.ogg

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

# Additional packages
-include vendor/xperience/config/packages.mk

# Versioning
-include vendor/xperience/config/version.mk

# SELinux Policy
-include vendor/xperience/sepolicy/sepolicy.mk

# Themes and Theme overlays
include vendor/themes/themes.mk

# Wallpapers
include vendor/xperience/config/wallpaper.mk

# Add our overlays
DEVICE_PACKAGE_OVERLAYS += vendor/xperience/overlay/common

# Exclude from RRO
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/xperience/overlay

# Include CM LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/xperience/overlay/dictionaries

# Squisher Location
SQUISHER_SCRIPT := vendor/xperience/tools/squisher

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false
