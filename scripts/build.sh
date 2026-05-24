#!/usr/bin/env bash

set -e

rm -rf .repo/local_manifests

repo init -u https://github.com/LineageOS/android.git -b lineage-23.2 --git-lfs

git clone https://github.com/Shaddowalker-26/android_local_manifests.git \
-b main \
.repo/local_manifests

repo sync -c --no-tags --no-clone-bundle -j$(nproc --all)

export BUILD_USERNAME=Shaddowalker-26
export BUILD_HOSTNAME=crave

git clone https://${KEYS_PAT}@github.com/Shaddowalker-26/android_vendor_keys.git \
vendor/lineage-priv/keys

export ANDROID_SIGNING_KEYS=vendor/lineage-priv/keys

source build/envsetup.sh

lunch lineage_spes-trunk_staging-userdebug

mka bacon
