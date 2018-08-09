# Charger
ifneq ($(WITH_XPE_CHARGER),false)
    BOARD_HAL_STATIC_LIBRARIES := libhealthd.xpe
endif

# QCOM HW crypto
ifeq ($(TARGET_HW_DISK_ENCRYPTION),true)
    TARGET_CRYPTFS_HW_PATH ?= vendor/qcom/opensource/cryptfs_hw
endif

# soong
include vendor/xperience/build/soong/soong_config.mk
