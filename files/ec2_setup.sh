#!/usr/bin/env bash

sudo dnf update -y
sudo dnf install -y python3-pip gcc gcc-c++ python3-devel
sudo -H python3 -m pip install numpy scikit-learn
sudo yum install -y cronie
