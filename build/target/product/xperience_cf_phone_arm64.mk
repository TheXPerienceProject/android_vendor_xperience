# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0

$(call inherit-product, device/google/cuttlefish/vsoc_arm64/phone/aosp_cf.mk)

include vendor/xperience/build/target/product/xperience_generic_target.mk

TARGET_DISABLE_EPPE := true
TARGET_NO_KERNEL_OVERRIDE := true

# Overrides
PRODUCT_NAME := xperience_cf_phone_arm64
PRODUCT_MODEL := XPerience Cuttlefish phone built for arm64
