# Build fingerprint
ifneq ($(BUILD_FINGERPRINT),)
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)
endif

XPE_DISPLAY_VERSION := $(XPE_VERSION)

# Gaussian Blur
PRODUCT_PRODUCT_PROPERTIES += \
    ro.sf.blurs_are_expensive=1 \
    ro.surface_flinger.supports_background_blur=1

ifeq ($(XPERIENCE_CHANNEL),OFFICIAL)
# Signing
-include vendor/xperience/signing/keys.mk
endif
