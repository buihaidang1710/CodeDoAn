#!/bin/bash

# Duong dan den tep can gui
FILE_TO_SEND=""

# Khoa DSA(ky so)
DSA="dsaparam.pem"
DSA_PRIVATE_KEY="private_dsa_key.pem"
DSA_PUBLIC_KEY="public_dsa_key.pem"

# Khoa RSA(ma hoa)
RSA_PRIVATE_KEY="rsa_private.pem"
RSA_PUBLIC_KEY="rsa_public.pem"

# Tep dau ra 
ENC_FILE="message.enc"
SIG_FILE="message.sig"

# Dia chi may nhan
REMOTE_USER=""
REMOTE_HOST=""
REMOTE_PATH=""

# Buoc 1 : Tao khoa DSA 
if [ ! -f "$DSA_PRIVATE_KEY" ]; then
  echo "Tao khoa DSA..."
  openssl dsaparam -out "$DSA" 2048
  openssl gendsa -out "$DSA_PRIVATE_KEY" "$DSA"
  openssl dsa -in "$DSA_PRIVATE_KEY" -pubout -out "$DSA_PUBLIC_KEY"
fi

# Buoc 2 : Tao khoa RSA
if [ ! -f "$RSA_PRIVATE_KEY" ]; then
  echo "Tao khoa RSA..."
  openssl genpkey -algorithm RSA -out "$RSA_PRIVATE_KEY" -pkeyopt rsa_keygen_bits:2048
  openssl rsa -in "$RSA_PRIVATE_KEY" -pubout -out "$RSA_PUBLIC_KEY"
fi

# Buoc 3 : Ma hoa tep
echo "Ma hoa tep"
openssl rsautl -encrypt -inkey "$RSA_PUBLIC_KEY" -pubin -in "$FILE_TO_SEND" -out "$ENC_FILE"

# Buoc 4 : Ky so tep ma hoa
echo "Ky so tep ma hoa"
openssl dgst -sha256 -sign "$DSA_PRIVATE_KEY" -out "$SIG_FILE" "$ENC_FILE"

# Buoc 5 : Truyen tep qua SSH/SCP
echo "Truyen tep qua may nhan......."
scp "$ENC_FILE" "$SIG_FILE" "$DSA_PUBLIC_KEY" "$RSA_PRIVATE_KEY" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"

echo "Hoan thanh"

