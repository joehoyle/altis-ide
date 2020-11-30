FROM debian:buster

RUN apt-get update && apt-get install \
	--no-install-recommends \
	--yes \
	ca-certificates \
	curl \
	gnupg-agent \
	gnupg2 \
	httpie \
	openssl \
	less \
	openssh-server \
	php7.3 \
	php7.3-xml \
	procps \
	software-properties-common \
	sudo \
	tig \
	unzip \
	vim \
	wget \
	zip \
	&& update-ca-certificates

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - && \
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
	apt-get update && \
	apt-get install --yes docker-ce docker-ce-cli containerd.io

RUN sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
RUN curl https://getcomposer.org/composer-stable.phar --output /usr/local/bin/composer && chmod +x /usr/local/bin/composer
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.0/install.sh | bash

RUN curl -L https://github.com/cli/cli/releases/download/v1.3.0/gh_1.3.0_linux_amd64.deb --output /tmp/gh.deb && \
	dpkg -i /tmp/gh.deb && rm /tmp/gh.deb

RUN adduser --home /home/altis --shell /bin/bash --disabled-password --gecos '' altis
RUN chown altis:altis /home/altis
RUN passwd -d altis
RUN usermod -aG sudo altis
RUN echo 'altis ALL=NOPASSWD: ALL' >> /etc/sudoers
RUN adduser altis docker

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY motd /etc/motd
COPY --chown=altis:altis bashrc /home/altis/.bashrc
COPY sshd /etc/ssh/sshd_config
RUN sudo -u altis mkdir /home/altis/.ssh && sudo -u altis touch /home/altis/.ssh/authorized_keys
RUN ["chmod", "+x", "/docker-entrypoint.sh"]

RUN apt-get install --yes php7.3-mbstring
RUN sudo -u altis composer global require humanmade/psalm-plugin-wordpress
EXPOSE 443
EXPOSE 22

ENTRYPOINT [ "/docker-entrypoint.sh"]
WORKDIR /home/altis

CMD tail -f /dev/null
