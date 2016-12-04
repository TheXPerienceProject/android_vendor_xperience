$(call inherit-product, vendor/XPe/config/common_mini.mk)

# Required CM packages
PRODUCT_PACKAGES += \
LatinIME

# Include CM LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/XPe/overlay/dictionaries

ifeq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
    PRODUCT_COPY_FILES += \
        vendor/XPe/prebuilt/common/bootanimation/320.zip:system/media/bootanimation.zip
endif

$(call inherit-product, vendor/XPe/config/telephony.mk)
