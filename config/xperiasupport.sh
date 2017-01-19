#!/bin/sh

./vendor/XPe/tools/colors

# Print something to build output
echo ${bldppl}"Making dir..."${txtrst}
mkdir -v -p $OUT/target/product/"$DEVICE"/system/etc/permissions
mkdir -v -p $OUT/target/product/"$DEVICE"/system/etc/framework
echo ${bldppl}"Moving XPeria support files..."${txtrst}
cp -R vendor/prebuilt/XPeriaSupport $OUT/system/
