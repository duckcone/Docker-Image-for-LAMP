# Docker Image for LAMP

Repository for building a Docker image with **apache**, **mariadb** and **phpmyadmin**.

Before using this dockerfile, please make sure you have already install Docker on your device.

## Quick Start (First Use)
```shell
$ docker build . -t ubuntu:dev
$ docker run -p 9080:80 -p 9022:22 -p 9306:3306 -it --name ubuntu-dev ubuntu:dev
$ docker exec -it ubuntu-dev  bash
```

## Build Image
```bash
$ docker build . -t ubuntu:dev
```

## Run Image
```bash
$ docker run -p 9080:80 -p 9022:22 -p 9306:3306 -it --name ubuntu-dev ubuntu:dev
```

## Initialize Environment
```shell
$ docker exec -it ubuntu-dev bash # Getting into container shell
```

## Start the Container
```bash
$ docker start ubuntu-dev
```

## Stop the Container
```bash
$ docker start ubuntu-dev
```
## Reset Mysql Password
Please reset the password when you first use Mysql.

#### Environment variables

- `PHPMYADMIN_VERSION` (ex. 5.2.0)