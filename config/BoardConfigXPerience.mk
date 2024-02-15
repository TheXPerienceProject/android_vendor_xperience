# Charger
#ifneq ($(WITH_LINEAGE_CHARGER),false)
ifeq (true,false)
    BOARD_HAL_STATIC_LIBRARIES := libhealthd.lineage
endif

ifneq ($(TARGET_USES_KERNEL_PLATFORM),true)
include vendor/xperience/config/BoardConfigKernel.mk
endif

#ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include hardware/qcom-caf/common/BoardConfigQcom.mk
#endif

include vendor/xperience/config/BoardConfigSoong.mk

# Disable qmi EAP-SIM security
DISABLE_EAP_PROXY := true

# Default mount point symlinks to false
# since they are not used on 8998 and up
TARGET_MOUNT_POINTS_SYMLINKS ?= false
