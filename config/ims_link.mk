
$(shell mkdir -p $(TARGET_OUT_SYSTEM_EXT_APPS_PRIVILEGED)/ims/lib/arm64/ && pushd $(TARGET_OUT_SYSTEM_EXT_APPS_PRIVILEGED)/ims/lib/arm64 > /dev/null && ln -fs /system_ext/lib64/libimscamera_jni.so libimscamera_jni.so && popd > /dev/null)
$(shell mkdir -p $(TARGET_OUT_SYSTEM_EXT_APPS_PRIVILEGED)/ims/lib/arm64/ && pushd $(TARGET_OUT_SYSTEM_EXT_APPS_PRIVILEGED)/ims/lib/arm64 > /dev/null && ln -fs /system_ext/lib64/libimsmedia_jni.so libimsmedia_jni.so && popd > /dev/null)

