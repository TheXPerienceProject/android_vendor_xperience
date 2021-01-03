ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/xperience/config/BoardConfigQcom.mk
endif

include vendor/xperience/config/BoardConfigKernel.mk

# soong
include vendor/xperience/config/BoardConfigSoong.mk

PRODUCT_SOONG_NAMESPACES += $(PATHMAP_SOONG_NAMESPACES)
