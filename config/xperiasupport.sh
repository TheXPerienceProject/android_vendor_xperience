#!/bin/sh

./vendor/XPe/tools/colors

# Print something to build output
echo ${bldppl}"Moving XPeria support files..."${txtrst}
cp -A -V -R vendor/XPe/prebuilt/XPeriaSupport/etc/permissions/. $OUT/target/product/"$DEVICE"/system/etc/permissions/
cp -A -V -R vendor/XPe/prebuilt/XPeriaSupport/framework/. $OUT/target/product/"$DEVICE"/system/framework/
