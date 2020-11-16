FROM debian:buster

RUN apt-get update && apt-get install \
	--no-install-recommends \
	--yes \
	ca-certificates \
	curl \
	docker \
	openssl \
	less \
	php7.3 \
	unzip \
	wget \
	zip \
	&& update-ca-certificates

RUN apt-get install --yes docker-compose httpie sudo
RUN curl https://getcomposer.org/download/1.10.17/composer.phar --output /usr/local/bin/composer && chmod +x /usr/local/bin/composer

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.0/install.sh | bash

VOLUME /var/lib/docker
VOLUME /home/altis

RUN adduser --home /home/altis --shell /bin/bash --disabled-password --gecos '' altis
RUN passwd -d altis
RUN usermod -aG sudo altis
RUN adduser altis docker

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY bashrc /home/altis/.bashrc
RUN ["chmod", "+x", "/docker-entrypoint.sh"]

RUN apt-get install --yes php7.3-xml procps

EXPOSE 443

ENTRYPOINT [ "/docker-entrypoint.sh"]
