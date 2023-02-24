#
# XPerience Audio Files
#

ALARM_PATH := vendor/xperience/prebuilt/media/audio/alarms
NOTIFICATION_PATH := vendor/xperience/prebuilt/media/audio/notifications
RINGTONE_PATH := vendor/xperience/prebuilt/media/audio/ringtones
UI_PATH := vendor/xperience/prebuilt/media/audio/ui

#UI 
PRODUCT_COPY_FILES += \
    $(UI_PATH)/boot.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/ui/boot.ogg

# Alarms
PRODUCT_COPY_FILES += \
    $(ALARM_PATH)/CyanAlarm.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/alarms/CyanAlarm.ogg \
    $(ALARM_PATH)/NuclearLaunch.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/alarms/NuclearLaunch.ogg \
    $(ALARM_PATH)/Fuego.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/alarms/Fuego.ogg \
    $(ALARM_PATH)/xperia.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/alarms/xperia.ogg \
    $(ALARM_PATH)/Xperia_alarm.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/alarms/Xperia_alarm.ogg

# Notifications
PRODUCT_COPY_FILES += \
    $(NOTIFICATION_PATH)/CyanDoink.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/notifications/CyanDoink.ogg \
    $(NOTIFICATION_PATH)/CyanMail.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/notifications/CyanMail.ogg \
    $(NOTIFICATION_PATH)/CyanMessage.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/notifications/CyanMessage.ogg \
    $(NOTIFICATION_PATH)/Laser.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/notifications/Laser.ogg \
    $(NOTIFICATION_PATH)/Naughty.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/notifications/Naughty.ogg \
    $(NOTIFICATION_PATH)/Pong.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/notifications/Pong.ogg \
    $(NOTIFICATION_PATH)/Rang.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/notifications/Rang.ogg \
    $(NOTIFICATION_PATH)/Stone.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/notifications/Stone.ogg \
    $(NOTIFICATION_PATH)/Reminder.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/notifications/Reminder.ogg

# Ringtones
PRODUCT_COPY_FILES += \
    $(RINGTONE_PATH)/Boxbeat.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/ringtones/Boxbeat.ogg \
    $(RINGTONE_PATH)/CyanTone.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/ringtones/CyanTone.ogg \
    $(RINGTONE_PATH)/Highscore.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/ringtones/Highscore.ogg \
    $(RINGTONE_PATH)/Lyon.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/ringtones/Lyon.ogg \
    $(RINGTONE_PATH)/Rockin.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/ringtones/Rockin.ogg \
    $(RINGTONE_PATH)/Sheep.mp3:$(TARGET_COPY_OUT_PRODUCT)/media/audio/ringtones/Sheep.mp3 \
    $(RINGTONE_PATH)/Yukaay.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/ringtones/Yukaay.ogg \
    $(RINGTONE_PATH)/XPerienceRing.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/ringtones/XPerienceRing.ogg \
    $(RINGTONE_PATH)/Music_box.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/ringtones/Music_box.ogg \
    $(RINGTONE_PATH)/generic_xperia.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/ringtones/generic_xperia.ogg \
    $(RINGTONE_PATH)/garden_waltz.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/ringtones/garden_waltz.ogg