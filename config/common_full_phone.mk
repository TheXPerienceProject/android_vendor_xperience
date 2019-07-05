# Inherit common xperience stuff
$(call inherit-product, vendor/xperience/config/common_full.mk)

# Required CM packages
PRODUCT_PACKAGES += \
    LatinIME

# Include CM LatinIME dictionaries
    PRODUCT_PACKAGE_OVERLAYS += vendor/xperience/overlay/dictionaries

$(call inherit-product, vendor/xperience/config/telephony.mk)
