#!/bin/bash
set -ex

LOG="/var/log/cloud_release.txt"
date >> $LOG

# Install required packages
sudo apt-get update
sudo apt-get install -y docker.io jq

# key vault secrets
ACCESS_TOKEN="$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fvault.azure.net' -H Metadata:true -s | jq -r .access_token)"
SECRET_NAME=SECUREINFO 
SECRET_VALUE=$(curl https://${key_vault_name}.vault.azure.net/secrets/$SECRET_NAME?api-version=2016-10-01 -H "Authorization: Bearer $ACCESS_TOKEN" -s | jq -r .value)

# Docker 
if [ "${docker_user}X" != "X" ] && [ "${docker_pass}X" != "X" ]; then
    echo "Attempt to docker login " >> $LOG
    docker login -u "${docker_user}" -p "${docker_pass}" "${docker_registery}"
else 
    echo "Skip docker login"
fi 

# Setup mnt
mkdir -p /mnt/secrets
echo "Super secret name: $SECRET_NAME & Value: $SECRET_VALUE" > /mnt/secrets/index.html

docker pull "${docker_image_uri}"
docker run --name myapp -d -p 8080:80 -v /mnt/secrets:/usr/share/nginx/html/secrets "${docker_image_uri}"

echo "Docker image ${docker_image_uri} status" >> $LOG
docker ps >> $LOG
