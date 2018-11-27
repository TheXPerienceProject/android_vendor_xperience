LOCAL_PATH := $(call my-dir)
#java lib
include $(CLEAR_VARS)
LOCAL_SRC_FILES := $(call all-subdir-java-files)
LOCAL_MODULE := UxPerformance
LOCAL_MODULE_TAGS := optional
LOCAL_NO_STANDARD_LIBRARIES := true
LOCAL_JAVA_LIBRARIES := core-oj core-libart framework
LOCAL_MODULE_OWNER := xpe
LOCAL_PROGUARD_ENABLED := disabled
include $(BUILD_JAVA_LIBRARY)
