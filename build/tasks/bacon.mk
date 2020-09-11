# Copyright (C) 2017 Unlegacy-Android
# Copyright (C) 2017 The LineageOS Project
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

# -----------------------------------------------------------------
# Lineage OTA update package


XPE_TARGET_PACKAGE := $(PRODUCT_OUT)/xperience-$(XPE_VERSION).zip

# It's called md5 on Mac OS and md5sum on Linux
ifeq ($(HOST_OS),darwin)
MD5 := md5 -q
else
MD5 := md5sum
endif

.PHONY: bacon
bacon: $(INTERNAL_OTA_PACKAGE_TARGET)
	$(hide) ln -f $(INTERNAL_OTA_PACKAGE_TARGET) $(XPE_TARGET_PACKAGE)
	$(hide) $(MD5SUM) $(XPE_TARGET_PACKAGE) | sed "s|$(PRODUCT_OUT)/||" > $(XPE_TARGET_PACKAGE).md5sum
	@echo "Package Complete: $(XPE_TARGET_PACKAGE)" >&2
