#!/bin/bash

DECRYPTED_FILE="$1"
ENCRYPTED_FILE="$DECRYPTED_FILE.enc"

# Encrypt the file using a public key
gpg --output "$ENCRYPTED_FILE" --encrypt --recipient "Youness Houdaifa" "$DECRYPTED_FILE"

if [ $? -eq 0 ]; then
  echo "File encrypted successfully."
else
  echo "Error encrypting file."
  exit 1
fi
