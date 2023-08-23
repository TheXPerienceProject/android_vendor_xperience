# Charger
#ifneq ($(WITH_LINEAGE_CHARGER),false)
ifeq (true,false)
    BOARD_HAL_STATIC_LIBRARIES := libhealthd.lineage
endif

ifneq ($(TARGET_USES_KERNEL_PLATFORM),true)
include vendor/xperience/config/BoardConfigKernel.mk
endif

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/xperience/config/BoardConfigQcom.mk
endif

include vendor/xperience/config/BoardConfigSoong.mk
