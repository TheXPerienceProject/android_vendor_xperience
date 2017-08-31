# Inherit common xperience stuff
$(call inherit-product, vendor/xperience/config/common_mini.mk)

# Required XPe packages
PRODUCT_PACKAGES += \
LatinIME

ifeq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
    PRODUCT_COPY_FILES += \
        vendor/xperience/prebuilt/common/bootanimation/800.zip:system/media/bootanimation.zip
endif
