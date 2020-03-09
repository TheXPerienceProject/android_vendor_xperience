# Copyright (C) 2012 The Android Open Source Project
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

LOCAL_PATH := $(call my-dir)

#
# Prebuilt APKs

include $(CLEAR_VARS)
LOCAL_MODULE := XPeriaHome
LOCAL_MODULE_OWNER := sony
LOCAL_SRC_FILES := common/app/LauncherXPeria/Launcher.apk
LOCAL_OVERRIDES_PACKAGES := Launcher2 Launcher3PixelGo Launcher3Pixel
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .apk
LOCAL_MODULE_CLASS := APPS
LOCAL_PRIVILEGED_MODULE := true
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_DEX_PREOPT := false
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := WeatherClient
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := common/app/WeatherClient/WeatherClient.apk
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_CLASS := APPS
LOCAL_PRIVILEGED_MODULE := true
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_DEX_PREOPT := false
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := XPeriaWeather
LOCAL_MODULE_OWNER := sony
LOCAL_SRC_FILES := common/app/Weather/Weather.apk
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .apk
LOCAL_MODULE_CLASS := APPS
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_DEX_PREOPT := false
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := Alessa
LOCAL_MODULE_OWNER := xpe
LOCAL_SRC_FILES := common/app/Alessa_2.0.apk
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .apk
LOCAL_MODULE_CLASS := APPS
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_PRIVILEGED_MODULE := true
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := Notes
LOCAL_MODULE_OWNER := xpe
LOCAL_SRC_FILES := common/app/XPerienceNotes/Notes.apk
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .apk
LOCAL_MODULE_CLASS := APPS
LOCAL_CERTIFICATE := PRESIGNED
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := CommandCenter3
LOCAL_MODULE_OWNER := xpe
LOCAL_SRC_FILES := common/app/CommandCenter3/CommandCenter3.apk
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .apk
LOCAL_MODULE_CLASS := APPS
LOCAL_CERTIFICATE := PRESIGNED
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := XPerienceWallpapers
LOCAL_MODULE_OWNER := xpe
LOCAL_SRC_FILES := common/app/XPerienceWallpapers/XPerienceWallpapers.apk
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .apk
LOCAL_MODULE_CLASS := APPS
LOCAL_CERTIFICATE := shared
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := Gcam_Whyred
LOCAL_MODULE_OWNER := google
LOCAL_SRC_FILES := common/app/Gcam/Gcam_Whyred/Gcam_Whyred.apk
LOCAL_OVERRIDES_PACKAGES := SnapdragonCamera Snap Camera2 
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .apk
LOCAL_MODULE_CLASS := APPS
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_PRIVILEGED_MODULE := true
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := MotCamera
LOCAL_MODULE_OWNER := motorola
LOCAL_SRC_FILES := common/app/MotCamera/MotCamera.apk
LOCAL_OVERRIDES_PACKAGES := SnapdragonCamera Snap Camera2
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .apk
LOCAL_MODULE_CLASS := APPS
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_PRIVILEGED_MODULE := true
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := XPerienceCamera
LOCAL_MODULE_OWNER := bq
LOCAL_SRC_FILES := common/app/XPerienceCamerabq/XPerienceCamerabq.apk
LOCAL_OVERRIDES_PACKAGES := SnapdragonCamera Snap Camera2 MotCamera
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .apk
LOCAL_MODULE_CLASS := APPS
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_PRIVILEGED_MODULE := true
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := Turbo
LOCAL_SRC_FILES := common/app/Turbo/Turbo.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_CERTIFICATE := platform
LOCAL_PRIVILEGED_MODULE := true
LOCAL_MODULE_SUFFIX := .apk
LOCAL_DEX_PREOPT := false
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := SubstratumSignature
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := common/app/$(LOCAL_MODULE)/$(LOCAL_MODULE).apk
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_CLASS := APPS
LOCAL_BUILT_MODULE_STEM := package.apk
LOCAL_DEX_PREOPT := false
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE        := Longshot
LOCAL_SRC_FILES     := app/Longshot.apk
LOCAL_MODULE_TAGS   := optional
LOCAL_MODULE_CLASS  := APPS
LOCAL_CERTIFICATE   := platform
LOCAL_DEX_PREOPT := false
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_MULTILIB := both
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := MarkupGoogle
LOCAL_SRC_FILES := app/MarkupGoogle.apk
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := APPS
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_DEX_PREOPT := false
LOCAL_MULTILIB := both
include $(BUILD_PREBUILT)
