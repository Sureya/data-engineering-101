#!/usr/bin/env bash

# All these environment values must be set before we can execute the script.
export ENV="dev"
export API_KEY="432725751d6400d23f3652784b3d5938"
export DB_NAME="data_enginner"
export DB_USER="developer"
export DB_PWD="developer"
export DB_HOST="localhost"
export EC2_DNS_NAME="ec2-3-8-17-211.eu-west-2.compute.amazonaws.com"
export AWS_AUTH_FILE="~/.ssh/ec2_keypair_london.pem"

# This is your SSH key used for Github authentication
ssh-add -K ~/.ssh/cloudReach                                                                                                                                                                                                                                                                                                                                99 ↵

echo  '[aws]' > ${ENV}
echo ${EC2_DNS_NAME} >> ${ENV}
# The above two lines creates hosts file and add your EC2 instance to your host file.

ansible-playbook weather.yml --private-key=${AWS_AUTH_FILE} -K -u ubuntu -i ${ENV}
