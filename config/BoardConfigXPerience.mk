# Charger
ifneq ($(WITH_XPE_CHARGER),false)
    BOARD_HAL_STATIC_LIBRARIES := libhealthd.xpe
endif

# soong
include vendor/xperience/build/soong/soong_config.mk
