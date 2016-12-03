$(call inherit-product, vendor/XPe/config/common_mini.mk)

# Required CM packages
PRODUCT_PACKAGES += \
LatinIME

# Include CM LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/XPe/overlay/dictionaries

$(call inherit-product, vendor/XPe/config/telephony.mk)
