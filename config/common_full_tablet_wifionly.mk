# Inherit common XPe stuff
$(call inherit-product, vendor/XPe/config/common_full.mk)

# Required CM packages
PRODUCT_PACKAGES += \
LatinIME

# Include CM LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/XPe/overlay/dictionaries
