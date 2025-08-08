#!/bin/bash

MESSAGE_FILE=""
SIGNED_FILE=""
SIGNER_CERT=""
PRIVATE_KEY=""
REMOTE_USER=""
REMOTE_HOST=""
REMOTE_PATH=""

# Ky so email
openssl smime -sign -in "$MESSAGE_FILE" -text -signer "$SIGNER_CERT" -inkey "$PRIVATE_KEY" -out "$SIGNED_FILE"

# Gui email qua SCP
scp "$SIGNED_FILE" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
scp "$SIGNER_CERT" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"

echo "Signed and sent"

