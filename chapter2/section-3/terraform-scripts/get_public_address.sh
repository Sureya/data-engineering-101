#!/usr/bin/env bash

myip=$(curl ifconfig.me -s)
jq -n --arg myip "${myip}" '{"myip":$myip}'
