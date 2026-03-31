#!/bin/bash
set -e

# Keep original rust tweak from upstream repo
sed -i 's/ci-llvm=true/ci-llvm=false/g' feeds/packages/lang/rust/Makefile

# Remove OpenClash leftovers if present
rm -rf files/etc/openclash
rm -f files/etc/init.d/openclash
rm -f files/usr/bin/clash*
rm -rf files/usr/share/openclash

# Prepare directories
BIN_DIR="$GITHUB_WORKSPACE/openwrt/files/usr/bin"
XRAY_SHARE="$GITHUB_WORKSPACE/openwrt/files/usr/share/xray"
mkdir -p "$BIN_DIR" "$XRAY_SHARE"

WORK_DIR="$(mktemp -d)"
cd "$WORK_DIR"

# Xray
XRAY_VERSION="25.10.15"
curl -L -o xray.zip \
  "https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-arm64-v8a.zip"
unzip -o xray.zip
install -m 0755 xray "$BIN_DIR/xray"
[ -f geoip.dat ] && install -m 0644 geoip.dat "$XRAY_SHARE/geoip.dat"
[ -f geosite.dat ] && install -m 0644 geosite.dat "$XRAY_SHARE/geosite.dat"

# sing-box
SINGBOX_VERSION="1.12.12"
curl -L -o sing-box.tar.gz \
  "https://github.com/SagerNet/sing-box/releases/download/v${SINGBOX_VERSION}/sing-box-${SINGBOX_VERSION}-linux-arm64.tar.gz"
tar -xzf sing-box.tar.gz
install -m 0755 "sing-box-${SINGBOX_VERSION}-linux-arm64/sing-box" "$BIN_DIR/sing-box"

rm -rf "$WORK_DIR"
