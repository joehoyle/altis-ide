# Altis Development Environment

An integrated development environment for Altis via Docker

---

This project provides a fully configured Altis local development environment for use with VS Code's ability to [Developing inside a Container](https://code.visualstudio.com/docs/remote/containers).

## Getting Started

The whole development environment is wrapped up in a single docker image, `joehoyle/altis-ide:latest`. As multiple Altis projects should be developed in the single environment, it makes use of Docker internally. Therefore it's neccesary to run the container in proviliaged mode. All local Altis sites run on `https://*.altis.dev` so we must also forward port 443.

```
docker run -p 443:443 --privileged -it joehoyle/altis-ide
```

## Attach Volumes For Upgradability

The default `docker run` command will mean all projects are stored within the container. If the `joehoyle/altis-ide` docker image is updated, upgrading would mean losing all data in the container. You can create additional docker volumes that can be connected to the new container upgrade.

```
docker volume create altis-ide
docker run -p 443:443 --privileged -v altis-ide:/home/altis -it joehoyle/altis-ide
```

You can also create a volume for Docker within the container to use, this means each container upgrade will not need to re-download all the Altis Local Server images.

```
docker volume create altis-ide-docker
docker run -p 443:443 --privileged -v altis-ide:/home/altis -v altis-ide-docker:/var/lib/docker -it joehoyle/altis-ide
```
