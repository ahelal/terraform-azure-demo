#!/bin/bash
set -exo pipefail

LOG="/var/log/cloud_release.txt"
date >> $LOG

# Install required packages
sudo apt-get update
sudo apt-get install -y docker.io jq

# Fetch DB password from vault store
ACCESS_TOKEN="$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fvault.azure.net' -H Metadata:true -s | jq -r .access_token)"
SECRET_NAME=DBPASS 
SECRET_VALUE=$(curl https://${key_vault_name}.vault.azure.net/secrets/$SECRET_NAME?api-version=2016-10-01 -H "Authorization: Bearer $ACCESS_TOKEN" -s | jq -r .value)

APP_PORT=8080

# set env file for docker
echo "APP_DB_HOST=${db_host}" > ~/users_env
echo "APP_DB_USER=${db_user}@${db_host}" >> ~/users_env
echo "APP_DB_NAME=${db_name}" >> ~/users_env
echo "APP_DB_PASS=$SECRET_VALUE" >> ~/users_env
echo "APP_PORT=$APP_PORT" >> ~/users_env

# Docker registery login 
if [ "${docker_user}X" != "X" ] && [ "${docker_pass}X" != "X" ]; then
    echo "Attempt to docker login " >> $LOG
    docker login -u "${docker_user}" -p "${docker_pass}" "${docker_registery}"
else 
    echo "Skip docker login"
fi 

docker pull "${docker_image_uri}"
docker run --name users --env-file ~/users_env -d -p 8080:$APP_PORT "${docker_image_uri}"

echo "Docker image ${docker_image_uri} status" >> $LOG
docker ps >> $LOG
