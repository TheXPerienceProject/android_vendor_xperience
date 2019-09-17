#Buildtype and changelog
XPERIENCE_CHANGELOG := true

ifeq ($(XPE_BUILDTYPE), HOMECASE)
 export WITH_XPERIASUPPORT := false
endif
ifeq ($(XPE_BUILDTYPE), UNOFFICIAL)
 export WITH_XPERIASUPPORT := false
endif
ifeq ($(XPE_BUILDTYPE), NIGHTLY)
 export WITH_XPERIASUPPORT := true
endif
