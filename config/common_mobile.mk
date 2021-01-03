# Inherit common mobile xperience stuff
$(call inherit-product, vendor/xperience/config/common.mk)

# Default notification/alarm sounds
PRODUCT_PRODUCT_PROPERTIES += \
    ro.config.ringtone=XPerienceRing.ogg \
    ro.config.notification_sound=Reminder.ogg \
    ro.config.alarm_alert=Fuego.ogg

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.dun.override=0
endif

# AOSP packages
PRODUCT_PACKAGES += \
    Email \
    ExactCalculator \
    Exchange2

# XPerience packages
PRODUCT_PACKAGES += \
    Etar \
    Seedvault \
    Yunikon

ifeq ($(PRODUCT_TYPE), go)
PRODUCT_PACKAGES += \
    NightFallQuickStepGo

PRODUCT_DEXPREOPT_SPEED_APPS += \
    NightFallQuickStepGo
else
PRODUCT_PACKAGES += \
    NightFallQuickStep

PRODUCT_DEXPREOPT_SPEED_APPS += \
    NightFallQuickStep
endif

PRODUCT_DEXPREOPT_SPEED_APPS += \
    Settings \
    SystemUI \
    XPerienceOverlayStub

# Charger
PRODUCT_PACKAGES += \
    charger_res_images

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# SystemUI plugins
PRODUCT_PACKAGES += \
    QuickAccessWallet
