# Inherit common XPe stuff
$(call inherit-product, vendor/XPe/config/common.mk)

# Include XPe audio files
include vendor/XPe/config/xpe_audio.mk

# Required CM packages
PRODUCT_PACKAGES += \
LatinIME

# Include CM LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/XPe/overlay/dictionaries

ifeq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
    PRODUCT_COPY_FILES += \
        vendor/XPe/prebuilt/common/bootanimation/800.zip:system/media/bootanimation.zip
endif
