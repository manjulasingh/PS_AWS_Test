#!/bin/bash

# Update package index
sudo apt-get update -y

# Verify Java installation
java -version

# Add Jenkins GPG key
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Add Jenkins repository
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/" | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package index
sudo apt-get update -y

# Install Jenkins
sudo apt-get install -y jenkins

echo "Jenkins installation complete!"
echo "To start Jenkins manually, run: sudo systemctl start jenkins"
