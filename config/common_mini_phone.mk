$(call inherit-product, vendor/xperience/config/common_mini.mk)

# Required XPe packages
PRODUCT_PACKAGES += \
LatinIME

# Include XPe LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/xperience/overlay/dictionaries

$(call inherit-product, vendor/xperience/config/telephony.mk)
