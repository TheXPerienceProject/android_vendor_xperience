#!/bin/bash

# Usage: ./jack.sh <number of gigabytes to allocate to jack>
# example: ./jack 4 will allocate 4 gigabytes
 
export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx$1g"
./prebuilts/sdk/tools/jack-admin kill-server
./prebuilts/sdk/tools/jack-admin start-server
