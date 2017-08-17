# Charger
ifneq ($(WITH_XPE_CHARGER),false)
    BOARD_HAL_STATIC_LIBRARIES := libhealthd.xpe
endif

ifeq ($(BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE),)
  PRODUCT_PROPERTY_OVERRIDES += \
    ro.device.cache_dir=/data/cache
else
  PRODUCT_PROPERTY_OVERRIDES += \
    ro.device.cache_dir=/cache
endif
