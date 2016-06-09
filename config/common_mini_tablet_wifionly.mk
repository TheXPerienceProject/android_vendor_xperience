# Inherit common XPe stuff
$(call inherit-product, vendor/XPe/config/common_mini.mk)


# Required CM packages
PRODUCT_PACKAGES += \
LatinIME

ifeq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
    PRODUCT_COPY_FILES += \
        vendor/XPe/prebuilt/common/bootanimation/800.zip:system/media/bootanimation.zip
endif
