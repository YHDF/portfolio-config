#!/usr/bin/bash

#Prerequisites : Node and npm installed + Java and maven 

#This script assumes the protfolio project and protfolio-init are under the same directory

# Get the absolute path of the current script (portfolio-config)
CONFIG_DIR=$(dirname "$(realpath ".")")

# Define the expected path of the portfolio directory
PORTFOLIO_DIR="$CONFIG_DIR/portfolio"

#Define the environment running (Options : dev/prod)
ENV=$1

# Passkey used to decrypt the files
DECRYPTION_PASS_KEY=$2

# Add comment + implementation 
ACTION=$3

# Check if the portfolio directory exists
if [ ! -d "$PORTFOLIO_DIR" ]; then
  echo "Error: The portfolio directory does not exist under the same parent directory as portfolio-config."
  exit 1
fi

echo "Portfolio and portfolio-config are under the same directory."


# Cleaning secret files in portfolio-project
rm "$PORTFOLIO_DIR/deployment/database/.env"  
rm "$PORTFOLIO_DIR/deployment/webapp/webservice/.env"  
rm  "$PORTFOLIO_DIR/portfolio-client/localhost.pem"
rm "$PORTFOLIO_DIR/portfolio-client/localhost-key.pem"
rm -rf "$PORTFOLIO_DIR/profiles"


# Cleaning unencrypted proprety files
echo "Removing unencrypted files if they exist..." 
#find . -type f -name "*.enc" | while IFS= read -r enc_file; do rm "${enc_file::-4}"; done

#Running mvn clean for the project portfolio
mvn clean -f "$PORTFOLIO_DIR/pom.xml" 

#Running npm clean for the submodule portfolio-client 
npm --prefix "$PORTFOLIO_DIR/portfolio-client" run clean

find . -type f -name "*.enc" | while IFS= read -r enc_file; do ./decrypt.sh "$enc_file" "$DECRYPTION_PASS_KEY"; done

#Database .env
[[ -f "./.envs/database/.env" ]] && cp "./.envs/database/.env" "$PORTFOLIO_DIR/deployment/database" || exit 1

#Webservice .env
[[ -f "./.envs/webservice/.env" ]] &&  cp "./.envs/webservice/.env" "$PORTFOLIO_DIR/deployment/webapp/webservice" || exit 1

#Webclient SSL certificates
[[ -f "./profiles/localhost.pem" ]] &&  cp "./profiles/localhost.pem" "$PORTFOLIO_DIR/portfolio-client/" || exit 1
[[ -f "./profiles/localhost-key.pem" ]] &&  cp "./profiles/localhost-key.pem" "$PORTFOLIO_DIR/portfolio-client/" || exit 1

mkdir -p "$PORTFOLIO_DIR/profiles/$ENV"
cp -r "./profiles/$ENV" "$PORTFOLIO_DIR/profiles/"
cp "keystore.p12" "$PORTFOLIO_DIR/portfolio-webapp/src/main/resources/keystore.p12"

