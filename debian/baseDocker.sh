#!/bin/bash

echo "The script installs Docker, Docker Compose, Node Version Manager, and Make. It also adds the current user to the docker group."

sudo apt-get update
sudo apt-get install -y docker curl ca-certificates
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker compose
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose
# Allow docker in rootless mode to work on ports lower than 1024
sudo setcap 'cap_net_bind_service=+ep' /usr/bin/docker
sudo systemctl restart docker

# Install Node Version Manager
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install 20
nvm use 20

sudo usermod -aG docker $USER

# Install make tools
sudo apt-get install -y make

# Display further instructions
echo "Please log out and log back in to apply the group changes.
You will need to copy one of the example enviroment files to setup the environment variables.
Then run 'make' to build the project."
