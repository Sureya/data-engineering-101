#!/usr/bin/env bash

# Export all the constant values as environment variables
export APP_PATH="application_envs/weather_batch_app"
export REPO_NAME="data-engineering-101"
export REPO_URL="https://github.com/Sureya/data-engineering-101.git"
export FILES_DIRNAME="/home/ubuntu/code"
export VENV_DIRECTORY="/home/ubuntu/application_envs/weather_batch_app/bin"
export EXECUTABLE_FILE_PATH="/home/ubuntu/code/data-engineering-101/chapter2/"
export EXECUTABLE_FILE_NAME="version2.py"

# All credentials needed to execute our python application
export API_KEY="<API_KEY_GOES_HERE>"
export DATABASE_NAME="<DB_NAME>"
export DB_USER_NAME="<USER>"
export DB_PASSWORD="<PWD>"
export DB_HOST="<HOST>"

# Create a virtual environment
python3 -m venv ${APP_PATH}

# Clone the repo
(mkdir ${FILES_DIRNAME} && cd ${FILES_DIRNAME} &&  git clone ${REPO_URL})

# Install all the dependencies from requirements file
${VENV_DIRECTORY}/pip install -r ${FILES_DIRNAME}/${REPO_NAME}/chapter2/requirements.txt

# Execute the code
cd ${EXECUTABLE_FILE_PATH} ; ${VENV_DIRECTORY}/python  ${EXECUTABLE_FILE_NAME} --api_key=${API_KEY} --database=${DATABASE_NAME} \
--user=${DB_USER_NAME} --password=${DB_PASSWORD} --host=${DB_HOST}