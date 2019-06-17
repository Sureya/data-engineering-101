#!/usr/bin/env bash

# Export all the constant values as environment variables
export APP_PATH="application_envs/weather_batch_app"
export REPO_NAME="data-engineering-101"
export REPO_URL="https://github.com/Sureya/data-engineering-101.git"
export FILES_DIRNAME="/home/ubuntu/code"
export EXECUTABLE="/home/ubuntu/application_envs/weather_batch_app/bin"
export EXECUTABLE_FILE_PATH="/home/ubuntu/code/data-engineering-101/chapter2/version2.py"

# All credentials needed to execute our python application
export APP_API="<YOUR_API_KEY>"
export DB_USER="<YOUR_USER_NAME>"
export DB_PASSWORD="<YOUR_DB_PASSWORD>"
export DB_HOST="<YOUR_DB_HOST>"

# Install required packages
yes | sudo apt-get install git
yes | sudo add-apt-repository ppa:jonathonf/python-3.6
yes | sudo apt-get update
yes | sudo apt-get install python3.6
yes | sudo apt-get install python3-pip
yes | sudo apt-get install python3-venv

# Create virtual environment
python3 -m venv ${APP_PATH}

# Clone the repo
(mkdir ${FILES_DIRNAME} && cd ${FILES_DIRNAME} &&  git clone ${REPO_URL})

# Install all the dependencies from requirements file
${EXECUTABLE}/pip install -r ${FILES_DIRNAME}/${REPO_NAME}/chapter2/requirements.txt

# Execute the code
${EXECUTABLE}/python ${EXECUTABLE_FILE_PATH} --api_key=${APP_API} --database=postgres --user=${DB_USER} --password=${DB_PASSWORD} --host=${DB_HOST}