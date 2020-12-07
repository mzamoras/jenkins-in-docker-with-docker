FROM jenkins/jenkins

USER root

#UPDATING
RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-utils \
    curl \
    zsh \
    sudo \
    git \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    software-properties-common

#USRS AND PERMISSIONS
RUN groupadd docker
RUN groupadd chsh
RUN usermod -aG docker root
RUN usermod -aG docker jenkins
RUN usermod -aG chsh jenkins

#DOCKER
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
RUN apt-get update
RUN apt-get install --no-install-recommends -y docker-ce docker-ce-cli containerd.io

#OH MY ZSH CONFIGS
RUN curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -o /zsh-in-docker.sh
RUN chmod +x /zsh-in-docker.sh

#CHANGE SHELL PERMISSIONS
RUN zsh -c /zsh-in-docker.sh || true
RUN ln -f /bin/zsh /bin/sh
RUN sed -i 's/pam_rootok.so/pam_wheel.so\ttrust\tgroup=chsh/g' /etc/pam.d/chsh

#SCRIPT TO RUN ON BASH CREATION
RUN su jenkins
COPY ./bash-template.sh /bt.sh
RUN echo " source /bt.sh" >> /etc/bash.bashrc
RUN exit

#SCRIPT TO ACTIVATE DOCKER SOCKET
RUN (echo 'jenkins    ALL = (ALL) NOPASSWD: ALL' > /etc/sudoers.d/jenkinsnosudo &&\
  chmod 0440 /etc/sudoers.d/jenkinsnosudo)
USER jenkins