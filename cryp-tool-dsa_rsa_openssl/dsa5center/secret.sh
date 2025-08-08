#!/bin/bash

# Duong dan den tep can gui
FILE_TO_SEND=""

# Khoa RSA(ma hoa)
RSA_PRIVATE_KEY="rsa_private_key.pem"
RSA_PUBLIC_KEY="rsa_public_key.pem"

# Tep dau ra
ENC_FILE="secret.enc"

# Dia chi may nhan
REMOTE_USER=""
REMOTE_HOST=""
REMOTE_PATH=""

if [ ! -f "$RSA_PRIVATE_KEY" ]; then
  echo "Tao khoa RSA..."
  openssl genpkey -algorithm RSA -out "$RSA_PRIVATE_KEY" -pkeyopt rsa_keygen_bits:2048
  openssl rsa -in "$RSA_PRIVATE_KEY" -pubout -out "$RSA_PUBLIC_KEY"
fi

# Bước 3: Ma hoa tep
echo "Ma hoa tep"
openssl rsautl -encrypt -inkey "$RSA_PUBLIC_KEY" -pubin -in "$FILE_TO_SEND" -out "$ENC_FILE"

# Bước 5: Truyen tep qua SSH/SCP
echo "Truyen tep den may nhan..."
scp "$ENC_FILE" "$RSA_PRIVATE_KEY" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
echo "Secret da duoc gui"
