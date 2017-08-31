# Inherit common CM stuff
$(call inherit-product, vendor/xperience/config/common.mk)

PRODUCT_SIZE := mini

# Include XPe audio files
include vendor/xperience/config/xpe_audio.mk
