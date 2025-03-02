#!/bin/bash

# Update the package index
sudo yum update -y

# Install Python3 and pip
sudo yum install -y python3
sudo yum install -y python3-pip

# Install Flask
pip3 install Flask

# Create a directory for the Flask app
mkdir /home/ec2-user/app

# Navigate to the Flask app directory
cd /home/ec2-user/app

# Create the Flask app __init__.py file
cat <<EOF > __init__.py
from flask import Flask

app = Flask('Hello World')

from app import routes
EOF

# Create the Flask app routes.py file
cat <<EOF > routes.py
from app import app

@app.route('/')
@app.route('/index')
def index():
    return "Hello, World!"
EOF

# Navigate back to home 
cd

# Create a systemd service file for the Flask app
sudo bash -c 'cat <<EOF > /etc/systemd/system/flaskapp.service
[Unit]
Description=Flask Application

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user
Environment="FLASK_APP=app"
ExecStart=/usr/local/bin/flask run --host=0.0.0.0 --port=5001

[Install]
WantedBy=multi-user.target
EOF'

# Reload systemd to apply the new service file
sudo systemctl daemon-reload

# Enable the Flask service to start on boot
sudo systemctl enable flaskapp

# Start the Flask service
sudo systemctl start flaskapp