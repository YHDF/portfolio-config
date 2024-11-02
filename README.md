# Portfolio Project Setup

This project includes scripts to initialize, encrypt, decrypt, and clean files for the `portfolio` project. Follow the instructions below to set up and manage the project environment.

### Table of Contents
- [Prerequisites](#prerequisites)
- [File Structure](#file-structure)
- [Scripts Overview](#scripts-overview)
  - [init.sh](#initsh)
  - [encrypt.sh](#encryptsh)
  - [decrypt.sh](#decryptsh)
- [Usage Instructions](#usage-instructions)

### Prerequisites
Make sure the following tools are installed before running any scripts:
- **Node.js** and **npm**: For managing JavaScript dependencies and running `npm` commands.
- **Java** and **Maven**: For building and managing Java projects.
- **GPG**: For file encryption and decryption.

### File Structure
This project expects the following directory structure:
/parent-directory ├── portfolio-config │ ├── init.sh │ ├── encrypt.sh │ ├── decrypt.sh │ ├── .envs │ │ ├── database/.env │ │ └── webservice/.env │ └── profiles │ ├── dev/ │ └── prod/ └── portfolio ├── deployment │ ├── database/.env │ └── webapp/webservice/.env ├── portfolio-client │ ├── localhost.pem │ └── localhost-key.pem └── portfolio-webapp/src/main/resources/keystore.p12

### Scripts Overview

#### `init.sh`
The `init.sh` script initializes and sets up the environment for the `portfolio` project. It performs the following actions:

1. **Check Directory Structure**: Ensures that `portfolio` is under the same parent directory as `portfolio-config`.
2. **Clean Unencrypted Files**: Removes sensitive files if they exist in `portfolio`, including `.env` files, SSL certificates, and profiles.
3. **Clean Builds**:
   - Runs `mvn clean` for the `portfolio` Java project.
   - Runs `npm run clean` for the `portfolio-client` submodule.
4. **Decrypt Encrypted Files**: Uses `decrypt.sh` to decrypt `.enc` files in the current directory.
5. **Copy Configuration Files**:
   - Copies `.env` files from `portfolio-config` to the appropriate `portfolio` deployment locations.
   - Copies SSL certificates to `portfolio-client`.
   - Sets up environment-specific profiles and keystore files.

**Usage**:
```bash
./init.sh <environment> <decryption_pass_key> <action>
./encrypt.sh <file_to_encrypt>
./decrypt.sh <encrypted_file_path> <decryption_pass_key>
find . -type f ! -name "*.enc" ! -name "*.sh" -exec ./encrypt.sh {} \;
find . -type f ! -name "*.enc" ! -name "*.sh" ! -name "*.md" -exec rm {} \;