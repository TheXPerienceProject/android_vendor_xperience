# Inherit common CM stuff
$(call inherit-product, vendor/XPe/config/common.mk)

PRODUCT_SIZE := mini

# Include CM audio files
include vendor/XPe/config/cm_audio.mk

# Default notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Helium.ogg

