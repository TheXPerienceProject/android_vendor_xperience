# Inherit common xperience stuff
$(call inherit-product, vendor/xperience/config/common_mini.mk)

ifeq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
    PRODUCT_COPY_FILES += \
        vendor/xperience/prebuilt/common/bootanimation/800.zip:system/media/bootanimation.zip
endif

# Exclude AudioFX
TARGET_EXCLUDES_AUDIOFX := true
