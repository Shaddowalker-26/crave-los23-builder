#!/usr/bin/env bash

set -e


rm -rf .repo/local_manifests


repo init -u https://github.com/LineageOS/android.git -b lineage-23.2 --git-lfs


git clone https://github.com/Shaddowalker-26/android_local_manifests.git \
-b main \
.repo/local_manifests


if [ -f /usr/bin/resync ]; then
  /usr/bin/resync
else
  /opt/crave/resync.sh
fi


export BUILD_USERNAME=Shaddowalker-26
export BUILD_HOSTNAME=crave


source build/envsetup.sh


export ANDROID_SIGNING_KEYS=vendor/lineage-priv/keys


lunch lineage_spes-trunk_staging-userdebug


mka bacon
