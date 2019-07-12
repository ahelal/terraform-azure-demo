#!/bin/bash
set -eux

# Know script path
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT_DIR="${DIR}/../"

# Source variables
if [ -f "${ROOT_DIR}/vars/generated_vars.sh" ]; then
    echo "sourcing ${ROOT_DIR}/vars/generated_vars.sh"
    . "${ROOT_DIR}/vars/generated_vars.sh"
    docker login "$TF_VAR_DOCKER_REG" -u "$TF_VAR_DOCKER_USER" -p "$TF_VAR_DOCKER_PASS"
fi

cd "${ROOT_DIR}/Docker"

VERSION="0.1.0" 
docker build . -t "$TF_VAR_DOCKER_REG/users:$VERSION" -f Dockerfile-python
docker push "$TF_VAR_DOCKER_REG/users:$VERSION"

VERSION="0.1.0"
COLOR="RED" 
docker build  --build-arg COLOR="${COLOR}" --build-arg VERSION="${VERSION}" . -t "$TF_VAR_DOCKER_REG/myapp:$VERSION" -f Dockerfile-nginx
docker push "$TF_VAR_DOCKER_REG/myapp:$VERSION" 

VERSION="0.1.1"
COLOR="YELLOW" 
docker build  --build-arg COLOR="${COLOR}" --build-arg VERSION="${VERSION}" . -t "$TF_VAR_DOCKER_REG/myapp:$VERSION" -f Dockerfile-nginx
docker push "$TF_VAR_DOCKER_REG/myapp:$VERSION"

VERSION="0.2.0" 
COLOR="BLUE" 
docker build  --build-arg COLOR="${COLOR}" --build-arg VERSION="${VERSION}" . -t "$TF_VAR_DOCKER_REG/myapp:$VERSION" -f Dockerfile-nginx
docker push "$TF_VAR_DOCKER_REG/myapp:$VERSION"
