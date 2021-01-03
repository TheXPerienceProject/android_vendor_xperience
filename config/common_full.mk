# Inherit common xperience stuff
$(call inherit-product, vendor/xperience/config/common_mobile.mk)

PRODUCT_SIZE := full

# Recorder
PRODUCT_PACKAGES += \
    Recorder
