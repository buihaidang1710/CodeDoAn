#!/bin/bash

# Đường dẫn tệp nhận được
ENC_FILE="secret.enc"
RSA_PRIVATE_KEY="rsa_private_key.pem"
DECODED_FILE="secret_decode.txt"

# Bước 1: Giải mã tệp
echo "Giải mã tệp..."
openssl rsautl -decrypt -inkey "$RSA_PRIVATE_KEY" -in "$ENC_FILE" -out "$DECODED_FILE"
