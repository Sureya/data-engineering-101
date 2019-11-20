#!/usr/bin/env bash

set -e #Fail on first error


#***********************************************************
# All these environment values must be set before we can execute the script.
export ENV="dev"
export API_KEY="432725751d6400d23f3652784b3d5938"
export DB_NAME="chapter2"
export DB_USER="developer"
export DB_PWD="developer"
export DB_HOST="chapter2.ctqb5q4pi1qe.eu-west-2.rds.amazonaws.com"
export EC2_DNS_NAME="ec2-18-130-247-172.eu-west-2.compute.amazonaws.com"
export AWS_AUTH_FILE="/Users/sureyasathiamoorthi/Desktop/personal-aws/creds/de.pem"
#***********************************************************

# This is your SSH key used for Github authentication
ssh-add -K ~/.ssh/id_rsa # If you have used different KEY file for authenticating GitHub please change the filename

rm -rf ${ENV}
echo  '[aws]' >> ${ENV}
echo ${EC2_DNS_NAME} >> ${ENV}
# The above two lines creates hosts file and add your EC2 instance to your host file.
ansible-playbook weather.yml --private-key=${AWS_AUTH_FILE} -K -u ubuntu -i ${ENV}
