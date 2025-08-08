#!/bin/bash

# Duong dan den tep nhan duoc
ENC_FILE="message.enc"
SIG_FILE="message.sig"
DSA_PUBLIC_KEY="public_dsa_key.pem"
RSA_PRIVATE_KEY="rsa_private.pem"

# Tep sau khi giai ma
DECODED_FILE=""

# Buoc 1 : Giai ma tep 
echo "Giai ma tep..."
openssl rsautl -decrypt -inkey "$RSA_PRIVATE_KEY" -in "$ENC_FILE" -out "$DECODED_FILE"

# Buoc 2 : Xac minh chu ky
echo "Xac minh chu ky..."
openssl dgst -sha256 -verify "$DSA_PUBLIC_KEY" -signature "$SIG_FILE" "$ENC_FILE"

# Kiem tra ket qua 
if [ $? -eq 0 ]; then
  echo "Message da duoc luu"
else
  echo "Xac minh chu ky : That bai"
  exit 1
fi

