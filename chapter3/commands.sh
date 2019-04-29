#!/usr/bin/env bash
sudo apt-get install git
sudo add-apt-repository ppa:jonathonf/python-3.6
sudo apt-get update
sudo apt-get install python3.6
sudo apt-get install python3-pip
sudo apt-get install python3-venv
python3 -m venv application_envs/weather_batch_app

mkdir code
cd code
git clone https://github.com/Sureya/data-engineering-101.git



