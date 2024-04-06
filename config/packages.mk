# Additional packages
# themes
# $(call inherit-product, vendor/themes/themes.mk)

# Include AOSP audio files
include vendor/xperience/config/aosp_audio.mk

# Include xperience audio files
include vendor/xperience/config/xpe_audio.mk

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# Telephony
PRODUCT_PACKAGES += \
    ims-ext-common \
    ims_ext_common.xml \
    qti-telephony-hidl-wrapper \
    qti_telephony_hidl_wrapper.xml \
    qti-telephony-utils \
    qti_telephony_utils.xml \
    telephony-ext

#ifneq (,$(filter telephony, $(TARGET_COMMON_QTI_COMPONENTS)))
#PRODUCT_BOOT_JARS += \
#    telephony-ext
#endif

# CellBroadcastReceiver
PRODUCT_PACKAGES += \
CellBroadcastReceiver

# Exchange support
PRODUCT_PACKAGES += \
    Exchange2

# Additional apps
PRODUCT_PACKAGES += \
    GameSpace \
    ExactCalculator \
    NightFallQuickStep \
    Seedvault \
    XPeriaWeather \
    Yunikon

# Repainter integration
PRODUCT_PACKAGES += \
    RepainterServicePriv

# Dummy for the weather
PRODUCT_PACKAGES += \
	com.sony.device

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig \
    SimpleSettingsConfig

# Wallet app for Power menu integration
# https://source.android.com/devices/tech/connect/quick-access-wallet
#PRODUCT_PACKAGES += \
#    QuickAccessWallet

# Use signing keys for only official builds
ifeq ($(XPERIENCE_CHANNEL),OFFICIAL)

# Only build OTA if official
PRODUCT_PACKAGES += \
    Updater

# XPerience postboot based on qcom file
PRODUCT_PACKAGES += \
    init.xperience.postboot.sh

endif

PRODUCT_PACKAGES += \
    charger_res_images

ifneq ($(WITH_XPERIENCE_CHARGER),false)
PRODUCT_PACKAGES += \
    xperience_charger_animation
endif

# FS tools
PRODUCT_PACKAGES += \
    fsck.exfat \
    fsck.ntfs \
    mount.ntfs \
    mke2fs \
    mkfs.exfat \
    mkfs.ntfs \
    tune2fs

# Include fs tools for dedicated recovery and ramdisk partitions.
PRODUCT_PACKAGES += \
    e2fsck_ramdisk \
    resize2fs_ramdisk \
    tune2fs_ramdisk

PRODUCT_PACKAGES += \
    e2fsck.recovery \
    resize2fs.recovery \
    tune2fs.recovery

# Permissions
PRODUCT_PACKAGES += \
    privapp-permissions-xperience.xml \
    privapp-permissions-xperience-product.xml \
    privapp-permissions-xperience-system_ext.xml

# Exempt DeskClock from Powersave
PRODUCT_PACKAGES += \
    deskclock.xml

# Backup Services whitelist
PRODUCT_PACKAGES += \
    backup.xml

# Hidden API whitelist
PRODUCT_PACKAGES += \
    xperience-hiddenapi-package-whitelist.xml

# Themes
PRODUCT_PACKAGES += \
    ThemePicker \
    WallpaperPicker2 \
    XPerienceOverlayStub

#Coral cant include this due to lower superpartition size
ifneq ($(TARGET_DONT_INCLUDE_XPEWALLS), true)
PRODUCT_PACKAGES += \
    XPerienceWallpapers
endif

PRODUCT_PACKAGES += \
    NavigationBarMode2ButtonOverlay \
    XPerienceImmersiveNavigationOverlay

# Dex preopt
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI \
    Settings \
    XPeriaWeather

#-include vendor/qcom/common/perf/packages.mk

# if exist track perf changes
-include vendor/extras/extras.mk

# SystemUI Clocks
$(call inherit-product, vendor/SystemuiClocks/products.mk)

# GApps
WITH_GMS ?= true
ifeq ($(WITH_GMS), true)
#TARGET_STOCK_GAPPS ?= true
$(call inherit-product, vendor/gapps/products/gapps.mk)

PRODUCT_PACKAGES += \
    XPerienceSetupWizard

endif

# fonts
PRODUCT_PACKAGES += \
    HarmonyOS-Sans-Italic.ttf \
    HarmonyOS-Sans.ttf \
    Lexend-VF.ttf \
    Manrope-VF.ttf \
    RobotoFallback-VF.ttf

# Font overlays
PRODUCT_PACKAGES += \
    FontAccuratistOverlay \
    FontAclonicaOverlay \
    FontAmaranteOverlay \
    FontAntipastoProOverlay \
    FontArbutusSourceOverlay \
    FontArvoLatoOverlay \
    FontBariolOverlay \
    FontCagliostroOverlay \
    FontCoconOverlay \
    FontComfortaaOverlay \
    FontComicSansOverlay \
    FontCoolstoryOverlay \
    FontEvolveSansOverlay \
    FontExotwoOverlay \
    FontFifa2018Overlay \
    FontFluidSansOverlay \
    FontFucekOverlay \
    FontGrandHotelOverlay \
    FontGoogleSansOverlay \
    FontHarmonySansOverlay \
    FontInterSourceOverlay \
    FontJTLeonorOverlay \
    FontLGSmartGothicOverlay \
    FontLemonMilkOverlay \
    FontLinotteOverlay \
    FontManropeOverlay \
    FontMiSansOverlay \
    FontNokiaPureOverlay \
    FontNothingDotHeadlineOverlay \
    FontNothingDotOverlay \
    FontNotoSerifSource \
    FontNunitoOverlay \
    FontOdudaOverlay \
    FontOnePlusSansOverlay \
    FontOnePlusSlateOverlay \
    FontOneUISansOverlay \
    FontOppoSansOverlay \
    FontOswaldOverlay \
    FontProductSansVHOverlay \
    FontQuandoOverlay \
    FontRedressedOverlay \
    FontReemKufiOverlay \
    FontRobotoCondensedOverlay \
    FontRobotoOverlay \
    FontRosemaryOverlay \
    FontRubikRubikOverlay \
    FontSamsungOneOverlay \
    FontSanFranciscoDisplayProSourceOverlay \
    FontSimpleDaySourceOverlay \
    FontSonySketchOverlay \
    FontStoropiaOverlay \
    FontSurferOverlay \
    FontUbuntuOverlay

# LS Clock Fonts
PRODUCT_PACKAGES += \
    ClockFontOppoSansOverlay \
    ClockFontGoogleSansOverlay \
    ClockFontNothingDotOverlay \
    ClockFontAdventProOverlay \
    ClockFontBigNoodleTiltingOverlay \
    ClockFontCherrySwashOverlay \
    ClockFontHeadlineOverlay \
    ClockFontRoadRageOverlay \
    ClockFontSnowstormOverlay \
    ClockFontViburOverlay \
    ClockFontAlienLeagueOverlay \
    ClockFontBikoOverlay \
    ClockFontGinoraSansOverlay \
    ClockFontRivieraOverlay \
    ClockFontUnionOverlay \
    ClockFontAccuratistOverlay \
    ClockFontAclonicaOverlay \
    ClockFontAmaranteOverlay \
    ClockFontBariolOverlay \
    ClockFontCagliostroOverlay \
    ClockFontCoconOverlay \
    ClockFontComfortaaOverlay \
    ClockFontComicSansOverlay \
    ClockFontCoolstoryOverlay \
    ClockFontExotwoOverlay \
    ClockFontFifa2018Overlay \
    ClockFontGrandHotelOverlay \
    ClockFontHarmonySansOverlay \
    ClockFontLatoOverlay \
    ClockFontLGSmartGothicOverlay \
    ClockFontLinotteOverlay \
    ClockFontNokiaPureOverlay \
    ClockFontNunitoOverlay \
    ClockFontOneplusSansOverlay \
    ClockFontOneplusSlateOverlay \
    ClockFontOswaldOverlay \
    ClockFontQuandoOverlay \
    ClockFontRedressedOverlay \
    ClockFontReemKufiOverlay \
    ClockFontRobotoCondensedOverlay \
    ClockFontRosemaryOverlay \
    ClockFontRubikOverlay \
    ClockFontSamsungOneOverlay \
    ClockFontSonySketchOverlay \
    ClockFontStoropiaOverlay \
    ClockFontSurferOverlay \
    ClockFontUbuntuOverlay \
    ClockFontVG5000Overlay \
    ClockFont3DIsometricBlackOverlay \
    ClockFont3DIsometricBoldOverlay \
    ClockFontBalticBoddenOverlay \
    ClockFontBalticCoastOverlay \
    ClockFontBalticDuneOverlay \
    ClockFontBalticStormOverlay \
    ClockFontCafe24DecoshadowOverlay \
    ClockFontFortaOverlay \
    ClockFontMuseoModernoOverlay \
    ClockFontMXWasgardOverlay \
    ClockFontNeptunCATOverlay \
    ClockFontProdeltCoOverlay \
    ClockFontRubikGlitchOverlay \
    ClockFontTourneyMediumOverlay \
    ClockFontVG5000Overlay \
    ClockFontOdibeeSansOverlay \
    ClockFontPermanentMarkerOverlay \
    ClockFontArcadeInterlacedOverlay \
    ClockFontDotComOverlay \
    ClockFontKarmaticArcadeOverlay \
    ClockFontLiquidCrystalOverlay \
    ClockFontV5PRFOverlay \
    ClockFontZeroFourOverlay \
    ClockFontxtrusionOverlay \
    ClockFontNeonDiscoOverlay \
    ClockFontlovenessthreeOverlay \
    ClockFontAlphaCloudsOverlay \
    ClockFontAlphaFlowersOverlay \
    ClockFontAlphaWoodOverlay \
    ClockFontBigCheeseOverlay \
    ClockFontBudmoJigglerOverlay \
    ClockFontBunnyRabbitsOverlay \
    ClockFontCFBadNewsOverlay \
    ClockFontCFOneTwoTreesOverlay \
    ClockFontCRACKMANOverlay \
    ClockFontELRIOTT2Overlay \
    ClockFontEasterBunnyOverlay \
    ClockFontFibographyOverlay \
    ClockFontHangedOverlay \
    ClockFontHotSweatOverlay \
    ClockFontKGOnlyHopeOverlay \
    ClockFontKaramuruhOverlay \
    ClockFontKingthingsOverlay \
    ClockFontKlyukinOverlay \
    ClockFontLMSCliffordOverlay \
    ClockFontLittleBunnyOverlay \
    ClockFontMessingLetternOverlay \
    ClockFontneon2Overlay \
    ClockFontPinewoodOverlay \
    ClockFontPlaidEventOverlay \
    ClockFontPlantsLettersOverlay \
    ClockFontQuickSouthOverlay \
    ClockFontREMPONKOverlay \
    ClockFontRomantiquesOverlay \
    ClockFontScrapItUpOverlay \
    ClockFontSpaceGameOverlay \
    ClockFontTH3MACHINEOverlay \
    ClockFontVTKSDURA3dOverlay \
    ClockFontZnikomitNo24Overlay \
    ClockFontACFilmstripOverlay \
    ClockFontAmpad3D2Overlay \
    ClockFontBetsyFlanaganOverlay \
    ClockFontCatOverlay \
    ClockFontConcentrateOverlay \
    ClockFontDiscoMidnightOverlay \
    ClockFontGautsMotelUpperRightOverlay \
    ClockFontNINJASOverlay \
    ClockFontStandardHeaderOverlay \
    ClockFontfrankfrtOverlay \
    ClockFontmunsteriaOverlay \
    ClockFontAlmonteSnowOverlay \
    ClockFontBrandayolqOverlay \
    ClockFontEditPointsOverlay \
    ClockFontEditPointsFilledOverlay \
    ClockFontFloorlightOverlay \
    ClockFontFuturrOverlay \
    ClockFontLowerAtmosphereOverlay \
    ClockFontMonbijouxClownpieceOverlay \
    ClockFontRoundheadsOverlay

# Statusbar Icons
#PRODUCT_PACKAGES += \
    AquariumSignalOverlay \
    BarsSignalOverlay \
    DeepSignalOverlay \
    HuaweiSignalOverlay \
    InsideSignalOverlay \
    IosSignalOverlay \
    PillsSignalOverlay \
    RoundSignalOverlay \
    SneakySignalOverlay \
    StrokeSignalOverlay \
    WavySignalOverlay \
    WeedWiFiOverlay \
    XperiaSignalOverlay \
    ZigZagSignalOverlay

# Themes
#PRODUCT_PACKAGES += \
    DarkBgOverlay \
    UnmonetThemeAndroidOverlay \
    UnmonetThemeSettingsOverlay \
    NexodusThemeAndroidOverlay \
    NexodusThemeSettingsOverlay \
    NexodusThemeSystemUIOverlay \
    ProjectOptronicThemeAndroidOverlay \
    ProjectOptronicThemeSettingsOverlay \
    ProjectOptronicThemeSystemUIOverlay \
    PacleggersThemeAndroidOverlay \
    PacleggersThemeSettingsOverlay \
    PacleggersThemeSystemUIOverlay \
    SolarizedThemeAndroidOverlay \
    SolarizedThemeSettingsOverlay \
    SolarizedThemeSystemUIOverlay \
    ShishuIllusionsThemeAndroidOverlay \
    ShishuIllusionsThemeSettingsOverlay \
    ShishuIllusionsThemeSystemUIOverlay \
    ShishuImmensityThemeAndroidOverlay \
    ShishuImmensityThemeSettingsOverlay \
    ShishuImmensityThemeSystemUIOverlay \
    ShishuThemeAndroidOverlay \
    ShishuThemeSettingsOverlay \
    ShishuThemeSystemUIOverlay \
    ShishuNightsThemeAndroidOverlay \
    ShishuNightsThemeSettingsOverlay \
    ShishuNightsThemeSystemUIOverlay \
    ShishuAmalgamationThemeAndroidOverlay \
    ShishuAmalgamationThemeSettingsOverlay \
    ShishuAmalgamationThemeSystemUIOverlay

# Udfps
ifeq ($(EXTRA_UDFPS_ANIMATIONS),true)
$(warning EXTRA_UDFPS_ANIMATIONS IS ${EXTRA_UDFPS_ANIMATIONS})
#PRODUCT_PACKAGES += \
    UdfpsResources
endif

# XPerience Overlays
PRODUCT_PACKAGES += \
    XPerienceBlackThemeOverlay

# Wi-Fi Icons
#PRODUCT_PACKAGES += \
    BarsWiFiOverlay \
    InsideWiFiOverlay \
    RoundWiFiOverlay \
    SneakyWiFiOverlay \
    StrokeWiFiOverlay \
    WavyWiFiOverlay \
    XperiaWiFiOverlay \
    ZigZagWiFiOverlay

# Register vendor fonts
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,vendor/xperience_themes/product/fonts/,$(TARGET_COPY_OUT_PRODUCT)/fonts) \
    vendor/xperience_themes/product/etc/fonts_customization.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/fonts_customization.xml

# Neural Network
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full-rtti

# Sensors
PRODUCT_PACKAGES += \
    android.frameworks.sensorservice@1.0.vendor

# SetupWizard
PRODUCT_PRODUCT_PROPERTIES += \
    setupwizard.theme=glif_v4 \
    setupwizard.feature.day_night_mode_enabled=true

# TextClassifier
PRODUCT_PACKAGES += \
    libtextclassifier_annotator_en_model \
    libtextclassifier_annotator_universal_model \
    libtextclassifier_actions_suggestions_universal_model \
    libtextclassifier_lang_id_model

# Volume panel dialog - SystemUI
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    sys.fflag.override.settings_volume_panel_in_systemui=true

# Translations
CUSTOM_LOCALES += \
    ast_ES \
    gd_GB \
    cy_GB \
    fur_IT