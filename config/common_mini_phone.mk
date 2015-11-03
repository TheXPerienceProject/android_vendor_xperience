# Inherit common XPe stuff
$(call inherit-product, vendor/XPe/config/common.mk)

# Include XPe audio files
include vendor/XPe/config/xpe_audio.mk

# Required CM packages
PRODUCT_PACKAGES += \
LatinIME

# Include CM LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/XPe/overlay/dictionaries

# Include XPe LatinIME dictionaries
PRODUCT_COPY_FILES += \
    vendor/XPe/prebuilt/XPEKey/app/ExternalKeyboardsInternational/ExternalKeyboardsInternational.apk:system/app/ExternalKeyboardsInternational/ExternalKeyboardsInternational.apk \
    vendor/XPe/prebuilt/XPEKey/app/textinput-tng/textinput-tng.apk:system/app/textinput-tng/textinput-tng.apk \
    vendor/XPe/prebuilt/XPEKey/app/textinput-tng/lib/arm/libswiftkeysdk-java.so:system/app/textinput-tng/lib/arm/libswiftkeysdk-java.so \
    vendor/XPe/prebuilt/XPEKey/app/xperia-keyboard-dictionaries/xperia-keyboard-dictionaries.apk:system/app/xperia-keyboard-dictionaries/xperia-keyboard-dictionaries.apk \
    vendor/XPe/prebuilt/XPEKey/etc/permissions/com.sony.device.xml:system/etc/permissions/com.sony.device.xml \
    vendor/XPe/prebuilt/XPEKey/framework/com.sony.device.jar:system/framework/com.sony.device.jar \
    vendor/XPe/prebuilt/XPEKey/lib/libswiftkeysdk-java.so:system/lib/libswiftkeysdk-java.so


ifeq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
    PRODUCT_COPY_FILES += \
        vendor/XPe/prebuilt/common/bootanimation/320.zip:system/media/bootanimation.zip
endif

$(call inherit-product, vendor/XPe/config/telephony.mk)
