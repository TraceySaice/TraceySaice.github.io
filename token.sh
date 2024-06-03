#!/bin/bash
# API登  录  URL
LOGIN_URL="https://alist.mindustry.ltd/api/auth/login"
# API复  制  文  件  URL
COPY_URL="https://alist.mindustry.ltd/api/fs/copy"
# API删  除  文  件  URL
REMOVE_URL="https://alist.mindustry.ltd/api/fs/remove"
# 用  户  名  和  密  码
USERNAME="admin"
PASSWORD="bvgqIMTE0105"
# 源  目  录  和  目  标  目  录
SRC_DIR="mdtx-cong"
DST_DIR="ydyun/Mindustry"
# 登  录  API并  获  取  令  牌
response=$(curl --location --request POST "$LOGIN_URL" \
                --header 'User-Agent: Apifox/1.0.0 (https://apifox.com)' \
                --header 'Content-Type: application/json' \
                --data-raw "{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD
\"}")
# 提  取  令  牌
token=$(echo "$response" | jq -r '.data.token')
if [ -z "$token" ]; then
    echo "登  录  失  败  ，  未  能  获  取  令  牌  "
    exit 1
fi
# 列  出  目  标  目  录  下  的  所  有  文  件
files_response=$(curl --location --request GET "$COPY_URL?src_dir=$DST_DIR" \
             --header "Authorization: $token" \
             --header 'User-Agent: Apifox/1.0.0 (https://apifox.com)' \
             --header 'Content-Type: application/json')
## 提  取  文  件  名  并  构  造  JSON数  组
#file_names=$(echo "$files_response" | jq -r '.[]')
#file_names_json=$(echo "$file_names" | jq -R '[.]')
# 如  果  目  标  目  录  下  有  文  件  ，  删  除  它  们
# if [ -n "$file_names_json" ]; then
    curl --location --request POST "$REMOVE_URL" \
        --header "Authorization: $token" \
        --header 'User-Agent: Apifox/1.0.0 (https://apifox.com)' \
        --header 'Content-Type: application/json' \
        --data-raw '{
    "names": [
        "$SRC_DIR"
    ],
    "dir": "ydyun/Mindustry"
}'
# fi
file_names=$(echo "$files_response" | jq -r '.[]')
file_names_json=$(echo "$file_names" | jq -R '[.]')
# 使 用 获 取 的 令 牌 执 行 复 制 操 作
curl --location --request POST "$COPY_URL" \
    --header "Authorization: $token" \
    --header 'User-Agent: Apifox/1.0.0 (https://apifox.com)' \
    --header 'Content-Type: application/json' \
    --data-raw "{\"src_dir\":\"$SRC_DIR\",\"dst_dir\":\"$DST_DIR\",\"names\":$fi
le_names_json}"
# 使  用  获  取  的  令  牌  执  行  复  制  操  作
#curl --location --request POST "$COPY_URL" \
#    --header "Authorization: $token" \
#    --header 'User-Agent: Apifox/1.0.0 (https://apifox.com)' \
#    --header 'Content-Type: application/json' \
#    --data-raw "{\"src_dir\":\"$SRC_DIR\",\"dst_dir\":\"$DST_DIR\",\"names\":$f
ile_names_json}"