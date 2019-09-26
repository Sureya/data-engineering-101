#!/usr/bin/env bash

# Install required packages
yes | sudo apt-get install git
yes | sudo add-apt-repository ppa:jonathonf/python-3.6
yes | sudo apt-get update
yes | sudo apt-get install python3.6
yes | sudo apt-get install python3-pip
yes | sudo apt-get install python3-venv
