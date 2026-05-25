#!/usr/bin/env bash

set -euo pipefail

# ── Validation ────────────────────────────────────────────────────────────────
: "${KEYS_PAT:?Error: KEYS_PAT environment variable is not set}"

# ── Config ────────────────────────────────────────────────────────────────────
DEVICE="spes"
BRANCH="lineage-23.2"
MANIFEST_URL="https://github.com/LineageOS/android.git"
LOCAL_MANIFESTS_URL="https://github.com/Shaddowalker-26/android_local_manifests.git"
KEYS_REPO="https://${KEYS_PAT}@github.com/Shaddowalker-26/android_vendor_keys.git"
KEYS_DIR="vendor/lineage-priv/keys"

echo "================================================"
echo " Building LineageOS ${BRANCH} for ${DEVICE}"
echo "================================================"

# ── Local Manifests ───────────────────────────────────────────────────────────
echo "[1/4] Setting up local manifests..."
rm -rf .repo/local_manifests

git clone "${LOCAL_MANIFESTS_URL}" \
    -b main \
    .repo/local_manifests

# ── Signing Keys ──────────────────────────────────────────────────────────────
echo "[2/4] Setting up signing keys..."
if [ -d "${KEYS_DIR}" ]; then
    echo "Keys directory already exists, pulling latest..."
    git -C "${KEYS_DIR}" pull
else
    git clone "${KEYS_REPO}" "${KEYS_DIR}"
fi

# ── Build ─────────────────────────────────────────────────────────────────────
echo "[3/4] Setting up build environment..."
export BUILD_USERNAME="Shaddowalker-26"
export BUILD_HOSTNAME="crave"

source build/envsetup.sh
lunch "lineage_${DEVICE}-trunk_staging-userdebug"

echo "[4/4] Starting build..."
mka bacon

echo "================================================"
echo " Build completed successfully!"
echo "================================================"
