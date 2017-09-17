# Insert new variables inside the XPerience structure
xperience_soong:
	$(hide) mkdir -p $(dir $@)
	$(hide) (\
	echo '{'; \
	echo '"XPerience": {'; \
	echo '},'; \
	echo '') > $(SOONG_VARIABLES_TMP)
