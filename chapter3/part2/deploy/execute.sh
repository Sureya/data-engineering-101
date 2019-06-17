#!/usr/bin/env bash

# This is your SSH key for Github
ssh-add -K ~/.ssh/id_rsa

export DNS_NAME="ec2-3-8-131-190.eu-west-2.compute.amazonaws.com"
echo  '[aws]' > staging
echo ${DNS_NAME} >> staging

ansible-playbook aws_python_app.yml --private-key=~/.ssh/ec2_keypair_london.pem -K -u ubuntu -i staging
