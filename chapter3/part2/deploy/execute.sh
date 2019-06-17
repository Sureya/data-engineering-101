#!/usr/bin/env bash

# This is your SSH key for Github
export ENV="dev"

export API_KEY="432725751d6400d23f3652784b3d5938"
export DB_NAME="data_enginner"
export DB_USER="developer"
export DB_PWD="developer"
export DB_HOST="localhost"

ssh-add -K ~/.ssh/cloudReach                                                                                                                                                                                                                                                                                                                                99 ↵

export EC2_DNS_NAME="ec2-3-8-17-211.eu-west-2.compute.amazonaws.com"
echo  '[aws]' > ${ENV}
echo ${EC2_DNS_NAME} >> ${ENV}

ansible-playbook weather.yml --private-key=~/.ssh/ec2_keypair_london.pem -K -u ubuntu -i ${ENV}
