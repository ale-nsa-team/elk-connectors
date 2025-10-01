#!/bin/bash

# ---- Load config ----
CONFIG_FILE="/home/elkadmin/appmon_config.env"
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file not found: $CONFIG_FILE"
  exit 1
fi
source "$CONFIG_FILE"

# --- Convert space-separated string into Bash array ---
IFS=' ' read -r -a FILES <<< "$UPLOAD_FILE_NAMES"

# --- Authenticate  ---
AUTH_URL="https://${SWITCH_IP}/?domain=auth&username=${USERNAME}&password=${PASSWORD}"

echo "Authenticating to the switch..."

AUTH_COOKIE=$(curl -sk --location --request GET "$AUTH_URL" \
  --header 'Accept: application/vnd.alcatellucentaos+json' \
  -D - | grep -i 'Set-Cookie: wv_sess=' | sed -E 's/^[Ss]et-[Cc]ookie: wv_sess=([^;]+);.*$/\1/')

if [[ -z "$AUTH_COOKIE" ]]; then
  echo "Authentication failed or cookie not found!"
  exit 1
fi

echo "Authentication successful. Session cookie: $AUTH_COOKIE"

# --- Prepare URL for pushing files ---
PUSH_URL="https://${SWITCH_IP}/?domain=mib&urn=alaAppMonConfig"

# --- Loop through files and upload each one ---
for FILE in "${FILES[@]}"; do
  echo "Uploading file: $FILE to $UPLOAD_FILE_URL"

  curl -sk --location --request POST "$PUSH_URL" \
    --header 'Accept: application/vnd.alcatellucentaos+json' \
    --header "Cookie: wv_sess=$AUTH_COOKIE" \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    --data-urlencode "mibObject0-T1=alaAppMonUploadFile:${FILE}" \
    --data-urlencode "mibObject1-T1=alaAppMonUploadFileUrl:${UPLOAD_FILE_URL}"

  echo "→ $FILE uploaded."
done

echo "All files uploaded."


