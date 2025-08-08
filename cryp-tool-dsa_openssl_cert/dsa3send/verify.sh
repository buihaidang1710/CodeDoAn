#!/bin/bash

SIGNED_FILE=""
VERIFIED_FILE=""
SENDER_CERT=""

# Xác thực email
openssl smime -verify -in "$SIGNED_FILE" -CAfile "$SENDER_CERT" -out "$VERIFIED_FILE"

if [ $? -eq 0 ]; then
    echo "Email was saved"
else
    echo "Signature verification failed"
fi

