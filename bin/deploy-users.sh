#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT_DIR="${DIR}/../"
VARS_DIR="${ROOT_DIR}/vars"

if [ -f "${VARS_DIR}/generated_vars.sh" ]; then
    echo "sourcing ${VARS_DIR}/generated_vars.sh"
    source "${VARS_DIR}/generated_vars.sh"
fi

if [ -f "${VARS_DIR}/terraform_variables.sh" ]; then
    echo "sourcing ${VARS_DIR}/terraform_variables.sh"
    source "${VARS_DIR}/terraform_variables.sh"
fi

cd "${ROOT_DIR}/terraform/users"

terraform init
terraform apply -auto-approve
