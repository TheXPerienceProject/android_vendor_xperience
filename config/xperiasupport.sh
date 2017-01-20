#!/bin/sh

./vendor/XPe/tools/colors

# Print something to build output
echo ${bldppl}"Moving XPeria support files..."${txtrst}
cp -a -R vendor/XPe/prebuilt/XPeriaSupport/etc/permissions/. out/target/product/"$DEVICE"/system/etc/permissions/
cp -a -R vendor/XPe/prebuilt/XPeriaSupport/framework/. out/target/product/"$DEVICE"/system/framework/
