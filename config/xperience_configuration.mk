
#well I add ringtones here for all devices
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.config.ringtone=XPerienceRing.ogg \
    ro.config.notification_sound=Reminder.ogg \
    ro.config.alarm_alert=Fuego.ogg

# Copy over the changelog to the device
PRODUCT_COPY_FILES += \
    vendor/xperience/DONATORS.mkdn:$(TARGET_COPY_OUT_SYSTEM)/etc/donators.txt

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    keyguard.no_require_sim=true \
    ro.opa.elegible_device=true \
    setupwizard.theme=glif_v3_light \
    setupwizard.enable_assist_gesture_training=true \
    ro.com.google.ime.theme_id=4

# init.d support
PRODUCT_COPY_FILES += \
    vendor/xperience/prebuilt/common/etc/init.d/00banner:$(TARGET_COPY_OUT_SYSTEM)/etc/init.d/00banner \
    vendor/xperience/prebuilt/common/bin/sysinit:$(TARGET_COPY_OUT_SYSTEM)/bin/sysinit
