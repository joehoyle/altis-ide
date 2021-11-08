FROM debian:bullseye

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
	php7.4 \
	php7.4-xml \
	procps \
	software-properties-common \
	sudo \
	tig \
	unzip \
	vim \
	wget \
	zip \
	&& update-ca-certificates

RUN echo curlling
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN cat /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
	$(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update && \
	apt-get install --yes docker-ce docker-ce-cli containerd.io

RUN sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
RUN curl https://getcomposer.org/composer-stable.phar --output /usr/local/bin/composer && chmod +x /usr/local/bin/composer
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.0/install.sh | bash

RUN test "$(uname -m)" = "aarch64" && export ARCH=arm64 || export ARCH=amd64 && \
	curl -L https://github.com/cli/cli/releases/download/v1.4.0/gh_1.4.0_linux_$ARCH.deb --output /tmp/gh.deb && \
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

RUN apt-get install --yes php7.4-mbstring
RUN sudo -u altis composer global require humanmade/psalm-plugin-wordpress
EXPOSE 443
EXPOSE 22

ENTRYPOINT [ "/docker-entrypoint.sh"]
WORKDIR /home/altis

CMD tail -f /dev/null
