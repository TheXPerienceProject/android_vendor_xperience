# Export rom name
export VENDOR := XPe
export XPERIENCE_CHANGELOG := true

#XPerience version
PRODUCT_VERSION_MAJOR := 12
PRODUCT_VERSION_MINOR := 1
PRODUCT_VERSION_MAINTENANCE := 0
ROM_VERSION_TAG := 1

#Build type
ifeq ($(XPE_BUILDTYPE), HOMECASE)
XPE_BUILDTYPE := HOMECASE
endif
ifeq ($(XPE_BUILDTYPE), NIGHTLY)
XPE_BUILDTYPE := NIGHTLY
endif
ifeq ($(XPE_BUILDTYPE), RELEASE)
XPE_BUILDTYPE := RELEASE
endif
ifeq ($(XPE_BUILDTYPE), EXPERIMENTAL)
XPE_BUILDTYPE := EXPERIMENTAL
endif

XPERIA SUPPORT
ifeq ($(XPE_BUILDTYPE), HOMECASE)
WITH_XPERIASUPPORT := false
endif
ifeq ($(XPE_BUILDTYPE), UNOFFICIAL)
WITH_XPERIASUPPORT := false
endif
ifeq ($(XPE_BUILDTYPE), NIGHTLY)
WITH_XPERIASUPPORT := true
endif
ifeq ($(XPE_BUILDTYPE), EXPERIMENTAL)
WITH_XPERIASUPPORT := false
endif
