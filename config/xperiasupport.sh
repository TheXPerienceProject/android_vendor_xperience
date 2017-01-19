#!/bin/sh

./vendor/XPe/tools/colors

# Print something to build output
echo ${bldppl}"Moving XPeria support files..."${txtrst}
cp -avr vendor/XPe/prebuilt/XPeriaSupport/etc/permissions/. $OUT/system/etc/permissions/
