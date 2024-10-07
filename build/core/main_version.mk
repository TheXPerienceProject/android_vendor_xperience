# Build fingerprint
ifneq ($(BUILD_FINGERPRINT),)
#ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)
endif

XPE_DISPLAY_VERSION := $(XPE_VERSION)

ifeq ($(XPERIENCE_CHANNEL),OFFICIAL)
# Signing
-include vendor/xperience/signing/keys.mk
endif
