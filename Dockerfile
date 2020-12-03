FROM jenkins/jenkins

#ZSH AND OH-MY-ZSH
USER root
RUN ["apt-get", "update"]
RUN ["apt-get", "install", "-y", "apt-utils"]
RUN ["apt-get", "install", "-y", "zsh"]
RUN sh -c "$(wget -q -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)" -- \
    -t robbyrussell
RUN zsh

#DOCKER COMMAND LINE INTERFACE
RUN wget -q https://download.docker.com/linux/debian/dists/stretch/pool/stable/amd64/docker-ce-cli_19.03.9~3-0~debian-stretch_amd64.deb -O \
    docker-ce-cli.deb
RUN chmod +x docker-ce-cli.deb
RUN dpkg -i docker-ce-cli.deb
RUN rm docker-ce-cli.deb

#OH MY ZSH FOR JENKINS USER
# RUN su jenkins
USER jenkins
RUN sh -c "$(wget -q -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)" -- \
    -t robbyrussell
RUN exit

USER root
RUN touch /var/run/docker.sock
RUN echo "running jenkins configurations"
RUN groupadd docker
RUN usermod -aG docker jenkins
RUN chown jenkins:docker /var/run/docker.sock

USER jenkins
RUN zsh


# FROM blabla
# RUN do stuff
# RUN chown -R foo /var/run/docker.sock
# USER jenkins
# VOLUME /var/run/docker.sock
# CMD ["blabla.sh"]



# USER root
# RUN echo "running jenkins configurations"
# RUN groupadd docker
# RUN usermod -aG docker jenkins
# RUN chown jenkins:docker /var/run/docker.sock
# USER jenkins
# ~