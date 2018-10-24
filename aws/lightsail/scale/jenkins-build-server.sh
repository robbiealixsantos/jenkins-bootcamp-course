#!/bin/bash

# Update from OS install
apt-get update -y

# Common utilities
apt-get install -y nano zip unzip wget curl git build-essentials

# Install Java 8
apt-get install -y openjdk-8-jdk openjdk-8-jdk-headless

# Docker (official)
apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

cd /etc/apt/sources.list.d
cat "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" >> docker.list
apt-get update -y
apt-get install -y docker-ce
docker --version

cd /usr/local

# Setup SDK Man
export SDKMAN_DIR="/usr/local/sdkman"
curl -s "https://get.sdkman.io" | bash
sleep 10
cat "sdkman_auto_answer=true" >> "$SDKMAN_DIR/etc/config"
source "$SDKMAN_DIR/bin/sdkman-init.sh"

sdk version
sdk install groovy
sdk install maven
sdk install gradle
sdk install scala
sdk install sbt
sdk install ant
sdk install kotlin
sdk install kscript

# Symlinks to tools
cd /usr/local
ln -s sdkman/candidates/maven maven
ln -s sdkman/candidates/ant ant
ln -s sdkman/candidates/groovy groovy
ln -s sdkman/candidates/gradle gradle
ln -s sdkman/candidates/sbt sbt
ln -s sdkman/candidates/scala scala
ln -s sdkman/candidates/kotlin kotlin
ln -s sdkman/candidates/kscript kscript

# Node via NVM
cd /usr/local
mkdir -p /usr/local/nvm
chmod 755 nvm
export NVM_DIR="/usr/local/nvm"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
sleep 10
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install node
nvm install --lts

# Setup Jenkins user
cd
adduser --disabled-password --gecos "" jenkins
adduser jenkins sudo
cd /home/jenkins
mkdir .ssh
chmod 700 .ssh
chown jenkins.jenkins .ssh
cp /home/ubuntu/.ssh/authorized_keys .
chmod 600 authorized_keys
chown jenkins.jenkins authorized_keys
