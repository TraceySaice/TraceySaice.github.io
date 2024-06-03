!/bin/bash
# 定  义  仓  库  和  用  户
REPO="MindustryX-work"
OWNER="TinyLake"
# 定  义  下  载  目  录
DOWNLOAD_DIR="/root/mdtx-wz-new"
# 定  义  标  签  名
TAG="client-wz-build"
# 检  查  是  否  提  供  了  新  的  标  签
rm -rf $DOWNLOAD_DIR/*
if [[ -n "$1" ]]; then
  TAG="$1"
fi
# 获  取  指  定  标  签  的  发  行  版  本
RELEASE_RESPONSE=$(curl -s "https://api.github.com/repos/$OWNER/$REPO/releases/tags/$TAG")
# 检  查  是  否  有  有  效  的  发  行  版  本  响  应
if [[ $(echo "$RELEASE_RESPONSE" | jq -r '.message') == "Not Found" ]]; then
  echo "指  定  的  标  签   '$TAG' 没  有  找  到  对  应  的  发  行  版  本  。  "
  exit 1
fi
# 获  取  发  行  版  本  的  资  产  列  表  并  按  日  期  排  序
ASSETS=$(echo "$RELEASE_RESPONSE" | jq -r '.assets[] | .browser_download_url' |
sort -t'/' -k5 -r | head -3)
# 遍  历  资  产  列  表  ，  下  载  最  新  的  三  个  资  产
for ASSET_URL in $ASSETS; do
  ASSET_NAME=$(basename "$ASSET_URL")
  # 下  载  资  产
  wget -P "$DOWNLOAD_DIR" "$ASSET_URL"
  echo "资  产  已  下  载  : $ASSET_NAME"
done
# 删  除  本  地  文  件  列  表  中  除  最  新  三  个  文  件  以  外  的  所  有  文  件
# find "$DOWNLOAD_DIR" -type f | sort -t'/' -k5 -r | tail -n +4 | xargs rm -f
echo "下  载  完  成  "