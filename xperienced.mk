#Buildtype and changelog
export XPE_BUILDTYPE := HOMECASE
export XPERIENCE_CHANGELOG := true
ifeq ($(XPE_BUILDTYPE), HOMECASE)
 export WITH_XPERIASUPPORT := false
endif
ifeq ($(XPE_BUILDTYPE), UNOFFICIAL)
 export WITH_XPERIASUPPORT := false
endif
ifeq ($(XPE_BUILDTYPE), NIGHTLY)
 export WITH_XPERIASUPPORT := false
endif

