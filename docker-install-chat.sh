#!/bin/bash

# Install Docker
sudo yum install -y docker docker-compose git
sudo service docker start
sleep 10

# Install docker-compose
sudo sh -c 'curl -L https://github.com/docker/compose/releases/download/1.6.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose'
sudo chmod +x /usr/local/bin/docker-compose

# Use docker-compose.yaml
sudo /usr/local/bin/docker-compose up -d mongo
sudo /usr/local/bin/docker-compose up -d rocketchat
sudo /usr/local/bin/docker-compose up -d hubot
