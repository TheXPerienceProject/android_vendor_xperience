#!/bin/bash

# Version 2.0.7, Adapted for XPerience.
# Some darwin additions
# Remove some java verification
# Make Changelog and Copy to rom system and some cleans

# We don't allow scrollback buffer
echo -e '\0033\0143'
clear

# Get current path
DIR="$(cd `dirname $0`; pwd)"
OUT="$(readlink $DIR/out)"
[ -z "${OUT}" ] && OUT="${DIR}/out"

# Prepare output customization commands
red=$(tput setaf 1)             #  red
grn=$(tput setaf 2)             #  green
blu=$(tput setaf 4)             #  blue
cya=$(tput setaf 6)             #  cyan
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldgrn=${txtbld}$(tput setaf 2) #  green
bldblu=${txtbld}$(tput setaf 4) #  blue
bldcya=${txtbld}$(tput setaf 6) #  cyan
txtrst=$(tput sgr0)             # Reset

#check for architecture
ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')

# Local defaults, can be overriden by environment
: ${PREFS_FROM_SOURCE:="false"}
if [ `uname -s` == "Darwin" ]; then
: ${THREADS:="$(sysctl -n machdep.cpu.core_count)"}
else
: ${THREADS:="$(cat /proc/cpuinfo | grep "^processor" | wc -l)"}
fi

# Import command line parameters
DEVICE="$1"
EXTRAS="$2"

if [ $ARCH = "64" ]; then
# Get build version
BUILDTYPE=$(cat $DIR/vendor/XPe/vendor.mk | grep 'XPE_BUILDTYPE := *' | sed  's/XPE_BUILDTYPE := //g')
MAJOR=$(cat $DIR/vendor/XPe/vendor.mk | grep 'PRODUCT_VERSION_MAJOR := *' | sed  's/PRODUCT_VERSION_MAJOR := //g')
MINOR=$(cat $DIR/vendor/XPe/vendor.mk | grep 'PRODUCT_VERSION_MINOR := *' | sed  's/PRODUCT_VERSION_MINOR := //g')
MAINTENANCE=$(cat $DIR/vendor/XPe/vendor.mk | grep 'PRODUCT_VERSION_MAINTENANCE := *' | sed  's/PRODUCT_VERSION_MAINTENANCE := //g')
TAG=$(cat $DIR/vendor/XPe/vendor.mk | grep 'ROM_VERSION_TAG := *' | sed  's/ROM_VERSION_TAG := //g')


if [ -n "$TAG" ]; then
VERSION=$MAJOR.$MINOR-$TAG.$BUILDTYPE
else
VERSION=$MAJOR.$MINOR.$BUILDTYPE
fi

# If there is no extra parameter, reduce parameters index by 1
if [ "$EXTRAS" == "true" ] || [ "$EXTRAS" == "false" ]; then
SYNC="$2"
UPLOAD="$3"
else
SYNC="$3"
UPLOAD="$4"
fi

# Get start time
res1=$(date +%s.%N)

echo -e "${cya}Building ${bldcya}XPerience $VERSION for $DEVICE ${txtrst}";
echo -e "${bldgrn}Start time: $(date) ${txtrst}"

# Decide what command to execute
case "$EXTRAS" in
threads)
echo -e "${bldblu}Please enter desired building/syncing threads number followed by [ENTER]${txtrst}"
read threads
THREADS=$threads
;;
clean|cclean)
echo -e "${bldblu}Cleaning intermediates and output files${txtrst}"
export CLEAN_BUILD="true"
[ -d "${DIR}/out" ] && rm -Rf ${DIR}/out/*
;;
esac

echo -e ""

export DEVICE=$DEVICE

#Generate Changelog
export CHANGELOG=true

# setup environment
echo -e "${bldblu}Setting up environment ${txtrst}"
export USE_CCACHE=1
export CCACHE_DIR=~/.ccache
# set ccache due to your disk space,set it at your own risk
if [ `uname -s` == "Darwin" ]; then
prebuilts/misc/darwin-x86/ccache/ccache -M 20G
else
prebuilts/misc/linux-x86/ccache/ccache -M 20G
fi

#Enable to remove build.prop
echo -e ""
fix_count=0
elif [ "$var" == "clean" ]
then
echo -e "${bldblu}Clearing previous build info ${txtrst}"
mka installclean
elif [ "$var" == "fix" ]
then
echo -e "skip for remove build.prop"
fix_count=1
fi
if [ "$fix_count" == "0" ]
then
echo -e "removing build.prop"
rm -f out/target/product/"$DEVICE"/system/build.prop
rm -Rf out/target/product/"$DEVICE"/obj/PACKAGING/

fi


# Fetch latest sources
if [ "$SYNC" == "true" ]; then
echo -e ""
echo -e "${bldblu}Fetching latest sources${txtrst}"
repo sync -j"$THREADS"
echo -e ""
fi

if [ -n "${INTERACTIVE}" ]; then
echo -e "${bldblu}Dropping to interactive shell${txtrst}"
echo -en "${bldblu}Remeber to lunch you device:"
if [ "${VENDOR}" == "XPe" ]; then
echo -e "[${bldgrn}lunch xpe_$DEVICE-userdebug${bldblu}]${txtrst}"
else
echo -e "[${bldgrn}lunch full_$DEVICE-userdebug${bldblu}]${txtrst}"
fi
bash --init-file build/envsetup.sh -i
else
# Setup environment
echo -e ""
echo -e "${bldblu}Setting up environment${txtrst}"
. build/envsetup.sh
echo -e ""

#making changelog on niglty roms
if [ "${BUILDTYPE}" == "NIGHTLY" ]; then
echo -e " changelog"
	./vendor/XPe/tools/changelog
	mv Changelog.txt out/target/product/"$DEVICE"/system/etc/CHANGELOG-XPE.txt
fi

# lunch/brunch device
echo -e "${bldblu}Lunching device [$DEVICE] ${cya}(Includes dependencies sync)${txtrst}"
export PREFS_FROM_SOURCE
lunch "xpe_$DEVICE-userdebug";

echo -e "${bldblu}Starting compilation${txtrst}"
mka bacon
fi
echo -e ""

# Get elapsed time
res2=$(date +%s.%N)
echo -e "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds)${txtrst}"
else
echo -e "${bldred}This script only supports 64 bit architecture${txtrst}"
fi
