#Use Android GO configs for devices with 1gb ram and 512 
#set in board configs
#XPERIENCE_GO_MODE := true   (to enable it
#XPERIENCE_GO_MODE_1GB := true  for 1gb ram and
#XPERIENCE_GO_MODE_512 := true if you want to use in 512mb ram mode

ifeq ($(XPERIENCE_GO_MODE_1GB),true)
# Inherit common Android Go defaults.
$(call inherit-product, build/target/product/go_defaults_common.mk)
endif

ifeq ($(XPERIENCE_GO_MODE_512),true)
# Inherit common Android Go defaults.
$(call inherit-product, build/target/product/go_defaults_512.mk)
endif

$(call inherit-product-if-exists, frameworks/base/data/sounds/AudioPackageGo.mk)
PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.foreground-heap-growth-multiplier=2.0

PRODUCT_PACKAGES += \
    Launcher3Go
