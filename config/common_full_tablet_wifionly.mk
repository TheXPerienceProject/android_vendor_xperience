# Inherit common xperience stuff
$(call inherit-product, vendor/xperience/config/common_full.mk)

# Required CM packages
PRODUCT_PACKAGES += \
LatinIME

# Include CM LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/xperience/overlay/dictionaries

ifeq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
    PRODUCT_COPY_FILES += \
        vendor/xperience/prebuilt/common/bootanimation/720.zip:system/media/bootanimation.zip
endif
