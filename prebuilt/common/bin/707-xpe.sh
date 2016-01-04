#!/sbin/sh
#
# /system/addon.d/707-xpe.sh
#
. /tmp/backuptool.functions

list_files() {
cat <<EOF
addon.d/707-xpe.sh
priv-app/AudioFX/AudioFX.apk
priv-app/ThemeChooser/ThemeChooser.apk
priv-app/ThemeStore/ThemeStore.apk
etc/permissions/com.cyngn.audiofx.xml
EOF
}

case "$1" in
  backup)
    list_files | while read FILE DUMMY; do
      backup_file $S/$FILE
    done
  ;;
  restore)
    list_files | while read FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file $S/$FILE $R
    done
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Stub
  ;;
  post-restore)
    # Stub
  ;;
esac
