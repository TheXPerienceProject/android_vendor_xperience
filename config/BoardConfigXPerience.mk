# Charger
#ifneq ($(WITH_LINEAGE_CHARGER),false)
ifeq (true,false)
    BOARD_HAL_STATIC_LIBRARIES := libhealthd.lineage
endif

include vendor/xperience/config/BoardConfigKernel.mk

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/xperience/config/BoardConfigQcom.mk
endif

include vendor/xperience/config/BoardConfigSoong.mk
