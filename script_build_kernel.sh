
#!/bin/bash
 
# ccache
export USE_CCACHE=1
export CCACHE_DIR=/home/ccache/klozz/kernel
prebuilts/misc/linux-x86/ccache/ccache -M 50G

# build
. build/envsetup.sh
lunch xpe_$device-userdebug
make bootimage -j4

