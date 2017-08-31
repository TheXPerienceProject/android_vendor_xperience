$(call inherit-product, vendor/xperience/config/common_mini.mk)

# Required XPe packages
PRODUCT_PACKAGES += \
LatinIME

# Include XPe LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/xperience/overlay/dictionaries

ifeq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
    PRODUCT_COPY_FILES += \
        vendor/xperience/prebuilt/common/bootanimation/320.zip:system/media/bootanimation.zip
endif

$(call inherit-product, vendor/xperience/config/telephony.mk)
