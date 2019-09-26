---
title: deployment
layout: post
---

# Chapter - 2
In this chapter, we will be exploring different ways to deploy our python application in AWS. 
For the ease of understanding, we will be splitting this chapter into 3 sections, 

*   **Section 1**: We will be deploying the application in AWS manually, by creating resource through AWS web console
*   **Section 2**: In this section, we will be writing a deployment script in Ansible
*   **Section 3**: In this section, we will be writing terraform scripts to create the AWS resource needed.

By doing this in three steps it would become clear on why we are using each technology and how it would make our life easier. 
For the scope of this example, we will be initiating the deployment scripts from our local machine.


Assuming we have a working application ready to deploy, we need a minimum of 3 steps 

*   Create Infrastructure resource 
    *   In this example, the EC2 server and RDS database
*   Configure the instance to the desired state
    *   Like installing _Git, Python3 _etc.. and other system-level packages that are needed to execute the script
*   Package & Deploy the application 
    *   Install _Virtualenv, install python libraries, etc… 


# Tech Stack

*   Cloud - [AWS](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/) 
*   Application - Python2.6
*   OS - [ubuntu](https://www.cheatography.com/davechild/cheat-sheets/linux-command-line/) 
*   [Shell script](https://www.shellscript.sh/index.html)
*   [Ansible](https://scotch.io/tutorials/getting-started-with-ansible)
*   [Terraform](https://learn.hashicorp.com/terraform/#getting-started)


## Section-1 Deploy your application Manually in AWS 

This is not the fanciest way to deploy an application, but if you never deployed an application
end to end, it helps to try it manually then automating, it would give a clear idea of why we would 
want to automate it in the first place. If you are familiar with what deployment script is and 
why we need it, you can skip to section 2.


## 2.1: Creating Infrastructure

Reference Links

*   [RDS](https://aws.amazon.com/rds/postgresql/)
*   [EC2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html)
*   [Bash](https://www.howtoforge.com/tutorial/linux-shell-scripting-lessons/)


### 2.1.1 - Create RDS database

*   Select RDS service and click create a database
*   Select PostgreSQL from engine option
*   Select Dev/test from use case
*   Select t2.micro for DB instance class
*   Give any suitable name for DB instance identifier
*   Give a suitable username and password, which we will be using in the later steps.
*   Click Next & Click create a database
*   Detailed instructions can be found [here](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_GettingStarted.CreatingConnecting.PostgreSQL.html)
*   Remember to 
    *   Enable public accessibility 
    *   Create a security group called de-lab and use that for all the resources we create. 
*   Wait until the **status** value becomes **Available**.
*   Make note of host value from the database


### 2.1.2 - Create an EC2 instance

*   Proceed to EC2 dashboard 
*   Quick guide for launching EC2 instance
    *   Select Launch instance 
    *   Select: **Ubuntu Server 18.04 LTS (HVM), SSD Volume Type **
    *   Select**: t2.micro**
    *   Click: **Next: Configure Instance Details**
    *   Click: **Next: Add Storage**
    *   Click: **Review & Launch**
    *   When you press the launch button, you will be prompted to select the key pair if you already have one, otherwise you will be asked to create one, please secure the file in your local machine, we will be using that key pair for all our exercises.
*   Detailed instructions available [here](https://docs.aws.amazon.com/quickstarts/latest/vmlaunch/step-1-launch-instance.html)
*   Once the instance is created,  login into your server via SSH as described [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html)


## 2.2: Configuration Management

Before we can begin to package our Python application we need to install system packages, to get our server to the desired configuration. Since we will be running Python application which is downloaded from Github, let's install the packages needed for that.


```bash
# Install required system-level packages
yes | sudo apt-get install git
yes | sudo add-apt-repository ppa:jonathonf/python-2.6
yes | sudo apt-get update
yes | sudo apt-get install python2.6
yes | sudo apt-get install python3-pip
yes | sudo apt-get install python3-venv
```



## 2.3: Packaging & Deploying the application

After installing system packages we can start packaging our application by creating virtualenv and installing python dependencies into the env.


```bash
#!/usr/bin/env bash

# Export all the constant values as environment variables
export APP_PATH="application_envs/weather_batch_app"
export REPO_NAME="data-engineering-101"
export REPO_URL="https://github.com/Sureya/data-engineering-101.git"
export FILES_DIRNAME="/home/ubuntu/code"
export EXECUTABLE="/home/ubuntu/application_envs/weather_batch_app/bin"
export EXECUTABLE_FILE_PATH="chapter1"

# All credentials needed to execute our python application
export API_KEY="<API_KEY_GOES_HERE>"
export DATABASE_NAME="<DB_NAME>"
export DB_USER_NAME="<USER>"
export DB_PASSWORD="<PWD>"
export DB_HOST="<HOST>"


# Create virtual environment
python3 -m venv ${APP_PATH}

# Clone the repo
(mkdir ${FILES_DIRNAME} && cd ${FILES_DIRNAME} &&  git clone ${REPO_URL})

# Install all the dependencies from requirements file
${EXECUTABLE}/pip install -r ${FILES_DIRNAME}/${REPO_NAME}/chapter2/requirements.txt

# Execute the code
${EXECUTABLE}/python ${EXECUTABLE_FILE_PATH} --api_key=${API_KEY} --database=${DATABASE_NAME} \
--user=${DB_USER_NAME} --password=${DB_PASSWORD} --host=${DB_HOST}
```

If the last command executes without any errors, we have successfully deployed our python application manually.


### 2.4 Automate configuration management & Application packaging

[Repo Link](https://github.com/Sureya/data-engineering-101/tree/master/chapter3/part2/deploy)

Reference Links

*   [Ansible](https://serversforhackers.com/c/an-ansible-tutorial) 
*   [Ansible - Video](https://www.youtube.com/watch?v=dCQpaTTTv98)

If we look at Part 2 & 3 from the previous section, it is just installing bunch of things into a server so that we can execute our application. 
In this section, we will be automating those steps via **Ansible,  **So that after creating infrastructure all we need to do is execute ansible playbook.
If you’re completely new to ansible, please read up on it. In short, Ansible is a YAML based commands executed sequentially to all the specified remote host.
