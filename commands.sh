# Install SSM Agent
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
sudo systemctl enable amazon-ssm-agent

# Install Java
sudo apt install default-jdk -y

# Install AWS CLI & AWS Iam Authenticator
sudo apt install -y unzip curl zip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
curl -Lo aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.5.9/aws-iam-authenticator_0.5.9_linux_amd64

# Install Docker
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker

# Install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y
sudo apt install -y jenkins
# sudo systemctl start jenkins
# sudo systemctl enable jenkins
# sudo systemctl status jenkins
# sudo cat /var/lib/jenkins/secrets/initialAdminPassword   # Jenkins admin password
# Jenkins username creation: jenkins-admin-user, password creation: jenkins_springboot4684$, name: testjenkins

# Verification of installation
java -version
aws --version
aws-iam-authenticator version
docker --version
systemctl status jenkins

# Install kubectl and eksctl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl
kubectl version --client

ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo install -m 0755 /tmp/eksctl /usr/local/bin && rm /tmp/eksctl
eksctl --help

# Execute Jenkins using docker
docker volume create jenkins_data
docker volume ls
docker network create jenkins_network
docker network ls

docker run -d \
  --name jenkins \
  --network jenkins_network \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_data:/var/jenkins_home \
  --restart unless-stopped \
  jenkins/jenkins:lts
docker ps
docker inspect jenkins | grep -i network
docker volume inspect jenkins_data
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

# Configure Jenkins user for Docker
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
sudo systemctl daemon-reload
sudo service docker stop
sudo service docker start
sudo su -s /bin/bash jenkins

# Create ECR repository and EKS cluster
aws configure
# Add the secret key, access secret key, us-east-2 and json as parameters

aws ecr create-repository \
  --repository-name springboot-jenkins-ecr-repo \
  --region us-east-2

eksctl create cluster \
  --name jenkins-cluster \
  --region us-east-2 \
  --without-nodegroup

cat /var/lib/jenkins/.kube/config > kubeconfig.txt

eksctl create nodegroup \
  --cluster jenkins-cluster \
  --region us-east-2 \
  --name jenkins-nodegroup \
  --node-type t3.small \
  --nodes 2

# Go to Manage Jenkins > Tools and configure maven
# Go to Jenkins & install plugins: Kubernetes CLI, Amazon ECR, Docker, Docker Pipeline (without restart)
# Configure Jenkins with GitHub and Kubernetes credentials
# Create a new Jenkins pipeline: springboot-jenkins-eks
# Use the pipeline script provided in the project folder
# Access the deployed application using the DNS of load balancer created by Kubernetes
