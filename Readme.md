# demo vmss

## Intro

Ths scripts deploys a demo app.

* Application Gateway
* Static Nginx Blue/green deployment in vm scale set
* Python app in vm scale set
* MariDB managed DB
* Container Registery 

## Setup

Install terraform 0.11.x
Install docker
Install azure CLI

```bash
git clone git@github.com:ahelal/terraform-azure-demo.git

# setup some vars in vars/terraform_variables.sh
echo "export TF_VAR_principal_name='yourAZureAccount@yourmail.com'" > ./vars/terraform_variables.sh
echo "export TF_VAR_pass='SOm232323dsd'"  >> ./vars/terraform_variables.sh
echo "export TV_VAR_env='test'" >> ./vars/terraform_variables.sh

cd bin
# Setup infrastructure
./up.sh 
# Deploy nginx 
## Deploy a verion
./deploy-nginx.sh a
## Deploy b verion
./deploy-nginx.sh b
## deploy users python app
./deploy-users.sh
```

To switch between apps you need to change that in the app gw from the portal 
