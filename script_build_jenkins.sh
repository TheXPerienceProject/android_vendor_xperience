#!/bin/bash
 
# ccache
export USE_CCACHE=1
export CCACHE_DIR=/home/ccache/klozz/xperience #replace "ssh_username" in this line with your own ssh username.
prebuilts/misc/linux-x86/ccache/ccache -M 50G

# Import command line parameters
DEVICE="$1"
EXTRAS="$2"
DEVICE2=$device
export DEVICE=$DEVICE
export DEVICE2=$DEVICE

# build
. build/envsetup.sh
lunch $device-userdebug
#breakfast $device
make clean

mkdir -v -p /home/klozz/xpe/out/target/product/addison/system/etc/
mkdir -v -p /home/klozz/xpe/out/target/product/wt88047/system/etc/
mkdir -v -p /home/klozz/xpe/out/target/product/athene/system/etc/
mkdir -v -p /home/klozz/xpe/out/target/product/a5ul/system/etc/
mkdir -v -p /home/klozz/xpe/out/target/product/falcon/system/etc/
mkdir -v -p /home/klozz/xpe/out/target/product/victara/system/etc/
mkdir -v -p /home/klozz/xpe/out/target/product/osprey/system/etc/
mkdir -v -p /home/klozz/xpe/out/target/product/titan/system/etc/
mkdir -v -p /home/klozz/xpe/out/target/product/merlin/system/etc/
        ./vendor/XPe/tools/changelog
        cp Changelog.txt /home/klozz/xpe/out/target/product/addison/system/etc/CHANGELOG-XPE.txt
        cp Changelog.txt /home/klozz/xpe/out/target/product/athene/system/etc/CHANGELOG-XPE.txt
        cp Changelog.txt /home/klozz/xpe/out/target/product/a5ul/system/etc/CHANGELOG-XPE.txt
        cp Changelog.txt /home/klozz/xpe/out/target/product/falcon/system/etc/CHANGELOG-XPE.txt
        cp Changelog.txt /home/klozz/xpe/out/target/product/victara/system/etc/CHANGELOG-XPE.txt
        cp Changelog.txt /home/klozz/xpe/out/target/product/osprey/system/etc/CHANGELOG-XPE.txt
        cp Changelog.txt /home/klozz/xpe/out/target/product/titan/system/etc/CHANGELOG-XPE.txt
        cp Changelog.txt /home/klozz/xpe/out/target/product/wt88047/system/etc/CHANGELOG-XPE.txt
        cp Changelog.txt /home/klozz/xpe/out/target/product/merlin/system/etc/CHANGELOG-XPE.txt

mkdir -v -p /home/klozz/xpe/out/target/product/addison/system/etc/permissions/
mkdir -v -p /home/klozz/xpe/out/target/product/addison/system/framework/

mkdir -v -p /home/klozz/xpe/out/target/product/athene/system/etc/permissions/
mkdir -v -p /home/klozz/xpe/out/target/product/athene/system/framework/


mkdir -v -p /home/klozz/xpe/out/target/product/falcon/system/etc/permissions/
mkdir -v -p /home/klozz/xpe/out/target/product/falcon/system/framework/

mkdir -v -p /home/klozz/xpe/out/target/product/a5ul/system/etc/permissions/
mkdir -v -p /home/klozz/xpe/out/target/product/a5ul/system/framework/

mkdir -v -p /home/klozz/xpe/out/target/product/victara/system/etc/permissions/
mkdir -v -p /home/klozz/xpe/out/target/product/victara/system/framework/

mkdir -v -p /home/klozz/xpe/out/target/product/titan/system/etc/permissions/
mkdir -v -p /home/klozz/xpe/out/target/product/titan/system/framework/

mkdir -v -p /home/klozz/xpe/out/target/product/osprey/system/etc/permissions/
mkdir -v -p /home/klozz/xpe/out/target/product/osprey/system/framework/

mkdir -v -p /home/klozz/xpe/out/target/product/wt88047/system/etc/permissions/
mkdir -v -p /home/klozz/xpe/out/target/product/wt88047/system/framework/

mkdir -v -p /home/klozz/xpe/out/target/product/merlin/system/etc/permissions/
mkdir -v -p /home/klozz/xpe/out/target/product/merlin/system/framework/

 cp -a -R /home/klozz/xpe/vendor/XPe/prebuilt/XPeriaSupport/etc/permissions/*.xml /home/klozz/xpe/out/target/product/addison/system/etc/permissions
 cp -a -R /home/klozz/xpe/vendor/XPe/prebuilt/XPeriaSupport/framework/*.jar out/target/product/addison/system/framework
 cp -a -R /home/klozz/xpe/vendor/XPe/prebuilt/XPeriaSupport/etc/permissions/*.xml /home/klozz/xpe/out/target/product/athene/system/etc/permissions
 cp -a -R /home/klozz/xpe/vendor/XPe/prebuilt/XPeriaSupport/framework/*.jar out/target/product/athene/system/framework/
 cp -a -R /home/klozz/xpe/vendor/XPe/prebuilt/XPeriaSupport/etc/permissions/*.xml /home/klozz/xpe/out/target/product/a5ul/system/etc/permissions
 cp -a -R /home/klozz/xpe/vendor/XPe/prebuilt/XPeriaSupport/framework/*.jar out/target/product/a5ul/system/framework/
 cp -a -R /home/klozz/xpe/vendor/XPe/prebuilt/XPeriaSupport/etc/permissions/*.xml /home/klozz/xpe/out/target/product/falcon/system/etc/permissions
 cp -a -R /home/klozz/xpe/vendor/XPe/prebuilt/XPeriaSupport/framework/*.jar out/target/product/falcon/system/framework/
 cp -a -R /home/klozz/xpe/vendor/XPe/prebuilt/XPeriaSupport/etc/permissions/*.xml /home/klozz/xpe/out/target/product/titan/system/etc/permissions
 cp -a -R /home/klozz/xpe/vendor/XPe/prebuilt/XPeriaSupport/framework/*.jar out/target/product/titan/system/framework/
 cp -a -R /home/klozz/xpe/vendor/XPe/prebuilt/XPeriaSupport/etc/permissions/*.xml /home/klozz/xpe/out/target/product/osprey/system/etc/permissions
 cp -a -R /home/klozz/xpe/vendor/XPe/prebuilt/XPeriaSupport/framework/*.jar out/target/product/osprey/system/framework/
 cp -a -R /home/klozz/xpe/vendor/XPe/prebuilt/XPeriaSupport/etc/permissions/*.xml /home/klozz/xpe/out/target/product/victara/system/etc/permissions
 cp -a -R /home/klozz/xpe/vendor/XPe/prebuilt/XPeriaSupport/framework/*.jar out/target/product/victara/system/framework/
 cp -a -R /home/klozz/xpe/vendor/XPe/prebuilt/XPeriaSupport/etc/permissions/*.xml /home/klozz/xpe/out/target/product/wt88047/system/etc/permissions
 cp -a -R /home/klozz/xpe/vendor/XPe/prebuilt/XPeriaSupport/framework/*.jar out/target/product/wt88047/system/framework/
 cp -a -R /home/klozz/xpe/vendor/XPe/prebuilt/XPeriaSupport/etc/permissions/*.xml /home/klozz/xpe/out/target/product/merlin/system/etc/permissions
 cp -a -R /home/klozz/xpe/vendor/XPe/prebuilt/XPeriaSupport/framework/*.jar out/target/product/merlin/system/framework/


make bacon -j8

