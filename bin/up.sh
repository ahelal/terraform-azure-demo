#!/bin/bash
set -e

# Know script path
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT_DIR="${DIR}/../"

# Source variables
if [ -f "${ROOT_DIR}/vars/terraform_variables.sh" ]; then
    echo "sourcing ${ROOT_DIR}/vars/terraform_variables.sh"
    . "${ROOT_DIR}/vars/terraform_variables.sh"
fi

# Setup rg,vnet,subnet, docker, and ...
cd "${ROOT_DIR}/terraform/basic"
terraform init
terraform apply -auto-approve

## build Docker images
cd "${ROOT_DIR}/bin"
./docker-build-push.sh

# build app gw
cd "${ROOT_DIR}/terraform/appGW" 
terraform init
terraform apply -auto-approve
