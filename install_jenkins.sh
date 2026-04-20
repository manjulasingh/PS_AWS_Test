#!/bin/bash

# Update package index
sudo apt-get update -y

# Install Java
sudo apt-get install -y fontconfig

# Install curl and gnupg if not present
sudo apt-get install -y curl gnupg

# Add Jenkins GPG key using curl
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | \
  sudo gpg --dearmor -o /usr/share/keyrings/jenkins-keyring.gpg

# Add Jenkins repository
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.gpg] \
  https://pkg.jenkins.io/debian-stable binary/" | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update and install Jenkins
sudo apt-get update -y
sudo apt-get install -y jenkins

echo "Jenkins installation complete!"
