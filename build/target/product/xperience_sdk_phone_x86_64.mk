# Copyright (C) 2021-2024 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

$(call inherit-product, device/generic/goldfish/64bitonly/product/sdk_phone64_x86_64.mk)

include vendor/xperience/build/target/product/xperience_generic_target.mk
include device/generic/goldfish/board/kernel/x86_64.mk

# include packages
-include vendor/xperience/config/packages.mk

# Always build modules from source
PRODUCT_MODULE_BUILD_FROM_SOURCE := true

# Enable mainline checking
#PRODUCT_ENFORCE_ARTIFACT_PATH_REQUIREMENTS := relaxed
# Set false to let us to build paranoidsense
PRODUCT_ENFORCE_ARTIFACT_PATH_REQUIREMENTS := false

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/priv-app/ParanoidSense/ParanoidSense.apk \
    system/etc/permissions/privapp_whitelist_co.aospa.sense.xml \
    system/etc/default-permissions/default_permissions_co.aospa.sense.xml \
    system/framework/telephony-ext.jar \
    system/fonts/RobotoFallback-VF.ttf \
    system/lib64/android.hardware.wifi% \
    system/etc/textclassifier/%

# Evita que se copien los APNs genéricos para que no choquen con los de la ROM
PRODUCT_COPY_FILES := $(filter-out %apns-conf.xml:%,$(PRODUCT_COPY_FILES))

# Overrides
PRODUCT_NAME := xperience_sdk_phone_x86_64
PRODUCT_MODEL := XPerience Android SDK built for x86_64

PRODUCT_SDK_ADDON_NAME := xperience
PRODUCT_SDK_ADDON_SYS_IMG_SOURCE_PROP := $(LOCAL_PATH)/source.properties

# Increase Partition size: 8G+8M
BOARD_SUPER_PARTITION_SIZE ?= 8598323200
BOARD_EMULATOR_DYNAMIC_PARTITIONS_SIZE ?= 8589934592

# Packaging sdk_addon target
PRODUCT_SDK_ADDON_COPY_FILES += \
    device/generic/goldfish/data/etc/advancedFeatures.ini:images/x86_64/advancedFeatures.ini \
    device/generic/goldfish/data/etc/encryptionkey.img:images/x86_64/encryptionkey.img \
    $(EMULATOR_KERNEL_FILE):images/x86_64/kernel-ranchu
