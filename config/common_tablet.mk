# Common settings and files
-include vendor/xperience/config/common.mk

# Add tablet overlays
DEVICE_PACKAGE_OVERLAYS += vendor/xperience/overlay/common_tablet

PRODUCT_CHARACTERISTICS := tablet
