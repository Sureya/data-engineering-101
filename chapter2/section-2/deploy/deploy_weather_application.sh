#!/usr/bin/env bash

set -e #Fail on first error

#***********************************************************
# All these environment values must be set before we can execute the script.
export ENV="dev"
export API_KEY="<YOUR-API-KEY>"
export DB_NAME="postgres"
export DB_USER="developer"
export DB_PWD="developer"
export DB_HOST="<YOUR-HOST-NAME-FROM RDS>"
export EC2_DNS_NAME="<YOUR-EC2-INSTANCE-IPV4-PUBLIC-DNS>"
export AWS_AUTH_FILE="<FULL/PATH/TO/YOUR/EXECUTE.pem>"
#***********************************************************

# This is your SSH key used for Github authentication
ssh-add -K ~/.ssh/id_rsa # If you have used different KEY file for authenticating GitHub please change the filename

echo  '[aws]' >> ${ENV}
echo ${EC2_DNS_NAME} >> ${ENV}
# The above two lines creates hosts file and add your EC2 instance to your host file.
ansible-playbook weather.yml --private-key=${AWS_AUTH_FILE} -K -u ubuntu -i ${ENV}
