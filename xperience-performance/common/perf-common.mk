# Copyright (C) 2018-2021 The XPerience Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

PRODUCT_SOONG_NAMESPACES += \
    vendor/xperience/xperience-performance/common/

ifeq ($(TARGET_KERNEL_VERSION),)
$(error "TARGET_KERNEL_VERSION is not defined yet, please define in your device makefile so it's accessible to QCOM common.")
endif

# Configs
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,vendor/xperience/xperience-performance/common/perf/configs/common,$(TARGET_COPY_OUT_VENDOR)/etc) \
    $(call find-copy-subdir-files,*,vendor/xperience/xperience-performance/common/perf/configs/$(TARGET_BOARD_PLATFORM),$(TARGET_COPY_OUT_VENDOR)/etc)

# Disable IOP HAL for select platforms.
ifeq ($(call is-board-platform-in-list, msm8937 msm8953 msm8998 qcs605 sdm660 sdm710),true)
PRODUCT_COPY_FILES += \
    vendor/xperience/xperience-performance/common/perf/vendor.qti.hardware.iop@2.0-service-disable.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/vendor.qti.hardware.iop@2.0-service-disable.rc
endif

# Disable the poweropt service for non 5.4 platforms.
ifneq ($(TARGET_KERNEL_VERSION),5.4)
PRODUCT_COPY_FILES += \
    vendor/xperience/xperience-performance/common/perf/poweropt-service-disable.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/poweropt-service-disable.rc
endif

# Packages
PRODUCT_PACKAGES += \
    libpsi.vendor \
    libtflite \
    vendor.qti.hardware.servicetracker@1.2.vendor

ifeq ($(TARGET_KERNEL_VERSION),5.4)
PRODUCT_PACKAGES += \
    task_profiles-qti
endif

# Properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.extension_library=libqti-perfd-client.so \
    vendor.power.pasr.enabled=true

ifeq ($(call is-board-platform-in-list, lahaina),true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.beluga.p=0x3 \
    ro.vendor.beluga.c=0x4800 \
    ro.vendor.beluga.s=0x900 \
    ro.vendor.beluga.t=0x240
endif

ifeq ($(TARGET_KERNEL_VERSION),5.4)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.perf.scroll_opt=true \
    vendor.power.pasr.enabled=true
endif

# Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/qcom/common/perf/perf-vendor.mk)