# Insert new variables inside the XPerience structure
xperience_soong:
	$(hide) mkdir -p $(dir $@)
	$(hide) (\
	echo '{'; \
        echo '"xperience": {'; \
        echo '},'; \
	echo '') > $(SOONG_VARIABLES_TMP)
