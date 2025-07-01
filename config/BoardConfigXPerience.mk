include vendor/xperience/config/BoardConfigKernel.mk

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include hardware/qcom-caf/common/BoardConfigQcom.mk
endif

include vendor/xperience/config/BoardConfigSoong.mk

# Disable qmi EAP-SIM security
DISABLE_EAP_PROXY := true

# Default mount point symlinks to false
# since they are not used on 8998 and up
TARGET_MOUNT_POINTS_SYMLINKS ?= false

# auto define LHDC
DISABLE_LHDC ?= true
ifneq ($(DISABLE_LHDC), true)
ifneq ($(filter $(UM_6_1_FAMILY),$(TARGET_BOARD_PLATFORM)),)
$(warning Enable LHDC on $(UM_6_1_FAMILY))
PRODUCT_SOONG_NAMESPACES += \
    vendor/savitech/lhdc/6.1
else ifneq ($(filter $(UM_5_15_FAMILY),$(TARGET_BOARD_PLATFORM)),)
$(warning Enable LHDC on $(UM_5_15_FAMILY))
PRODUCT_SOONG_NAMESPACES += \
    vendor/savitech/lhdc/5.15
else ifneq ($(filter $(UM_5_10_FAMILY),$(TARGET_BOARD_PLATFORM)),)
$(warning Enable LHDC on $(UM_5_10_FAMILY))
PRODUCT_SOONG_NAMESPACES += \
    vendor/savitech/lhdc/5.10
else ifneq ($(filter $(UM_5_4_FAMILY),$(TARGET_BOARD_PLATFORM)),)
$(warning Enable LHDC on $(UM_5_4_FAMILY))
PRODUCT_SOONG_NAMESPACES += \
    vendor/savitech/lhdc/5.4
else
 $(warning No LHDC support detected you can enable it manually just set the correct namespace)
endif
endif
