# Copyright (C) 2015 The CyanogenMod Project
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

CM_SRC_API_DIR := $(TOPDIR)prebuilts/cmsdk/api
INTERNAL_CM_PLATFORM_API_FILE := $(TARGET_OUT_COMMON_INTERMEDIATES)/PACKAGING/cm_public_api.txt
INTERNAL_CM_PLATFORM_REMOVED_API_FILE := $(TARGET_OUT_COMMON_INTERMEDIATES)/PACKAGING/cm_removed.txt
FRAMEWORK_CM_PLATFORM_API_FILE := $(TOPDIR)vendor/cmsdk/api/cm_current.txt
FRAMEWORK_CM_PLATFORM_REMOVED_API_FILE := $(TOPDIR)vendor/cmsdk/api/cm_removed.txt
FRAMEWORK_CM_API_NEEDS_UPDATE_TEXT := $(TOPDIR)vendor/xperience/build/core/apicheck_msg_current.txt

BUILD_HTTP_PREBUILT := $(TOP)/vendor/xperience/build/core/http_prebuilt.mk

BUILD_RRO_SYSTEM_PACKAGE := $(TOP)/vendor/xperience/build/core/system_rro.mk
