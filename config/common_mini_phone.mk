# Inherit common CM stuff
$(call inherit-product, vendor/XPe/config/common.mk)

# Include CM audio files
include vendor/XPe/config/cm_audio.mk

# Required CM packages
PRODUCT_PACKAGES += \
    LatinIME

ifeq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
    PRODUCT_COPY_FILES += \
        vendor/XPe/prebuilt/common/bootanimation/320.zip:system/media/bootanimation.zip
endif

$(call inherit-product, vendor/XPe/config/telephony.mk)
