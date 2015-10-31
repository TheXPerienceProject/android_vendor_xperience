# Inherit common XPe stuff
$(call inherit-product, vendor/XPe/config/common.mk)

# Include XPe audio files
include vendor/XPe/config/xpe_audio.mk

# Include XPe LatinIME dictionaries
PRODUCT_COPY_FILES += \
    vendor/XPe/prebuilt/XPEKey/app/ExternalKeyboardsInternational/ExternalKeyboardsInternational.apk:system/app/ExternalKeyboardsInternational/ExternalKeyboardsInternational.apk \
    vendor/XPe/prebuilt/XPEKey/app/textinput-tng/textinput-tng.apk:system/app/textinput-tng/textinput-tng.apk \
    vendor/XPe/prebuilt/XPEKey/app/textinput-tng/lib/arm/libswiftkeysdk-java.so:system/app/textinput-tng/lib/arm/libswiftkeysdk-java.so \
    vendor/XPe/prebuilt/XPEKey/app/xperia-keyboard-dictionaries/xperia-keyboard-dictionaries.apk:system/app/xperia-keyboard-dictionaries/xperia-keyboard-dictionaries.apk \
    vendor/XPe/prebuilt/XPEKey/etc/permissions/com.sony.device.xml:system/etc/permissions/com.sony.device.xml \
    vendor/XPe/prebuilt/XPEKey/framework/com.sony.device.jar:system/framework/com.sony.device.jar \
    vendor/XPe/prebuilt/XPEKey/lib/libswiftkeysdk-java.so:system/lib/libswiftkeysdk-java.so

# Optional XPe packages
PRODUCT_PACKAGES += \
    Galaxy4 \
    HoloSpiralWallpaper \
    LiveWallpapers \
    LiveWallpapersPicker \
    MagicSmokeWallpapers \
    NoiseField \
    PhaseBeam \
    PhotoTable \
    SoundRecorder \
    PhotoPhase

# Extra tools in XPe
PRODUCT_PACKAGES += \
    vim \
    zip \
    unrar \
    curl
