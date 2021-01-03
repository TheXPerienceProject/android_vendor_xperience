# Inherit common xperience stuff
$(call inherit-product, vendor/xperience/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include XPerience LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/xperience/overlay/dictionaries

$(call inherit-product, vendor/xperience/config/telephony.mk)
