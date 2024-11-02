#!/bin/bash

ENCRYPTED_FILE_PATH="$1"
ENCRYPTED_FILE="${ENCRYPTED_FILE_PATH##*/}"
DECRYPTED_FILE="${ENCRYPTED_FILE_PATH::-4}"


# Decrypt the file
gpg --batch --yes --pinentry-mode=loopback --passphrase "$2" --output "$DECRYPTED_FILE" --decrypt "$ENCRYPTED_FILE_PATH"

if [ $? -eq 0 ]; then
  echo "File decrypted successfully."
else
  echo "Error decrypting file."
  exit 1
fi
