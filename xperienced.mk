#Buildtype and changelog
export XPE_BUILDTYPE := HOMECASE
export XPERIENCE_CHANGELOG := true
ifneq ($(XPE_BUILDTYPE), HOMECASE)
 export WITH_XPERIASUPPORT := true
else 
 export WITH_XPERIASUPPORT := false
endif
ifneq ($(XPE_BUILDTYPE), UNOFFICIAL)
 export WITH_XPERIASUPPORT := true
else 
 export WITH_XPERIASUPPORT := false
endif

