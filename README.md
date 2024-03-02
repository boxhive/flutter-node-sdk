# Boxhive - Flutter SDK and NodeJS Docker image
[![Docker Image Version](https://img.shields.io/docker/v/boxhive/flutter-sdk-node)](https://hub.docker.com/repository/docker/boxhive/flutter-sdk-node)

[![Docker Pulls](https://img.shields.io/docker/pulls/boxhive/flutter-sdk-node)](https://hub.docker.com/repository/docker/boxhive/flutter-sdk-node)
[![Docker Stars](https://img.shields.io/docker/stars/boxhive/flutter-sdk-node)](https://hub.docker.com/repository/docker/boxhive/flutter-sdk-node)
[![Docker Size](https://img.shields.io/docker/image-size/boxhive/flutter-sdk-node/main)](https://hub.docker.com/repository/docker/boxhive/flutter-sdk-node)

Docker image built with Android SDK, Flutter SDK and nodeJS to handle NX monorepos containing both frontend, backend and flutter mobile apps.

## Usage

Use this image in gitlab-ci or any other CI you need.

```yaml
image: boxhive/flutter-sdk-node:latest
```

## Image tools versions

* Flutter SDK: `3.19.2`
* Android SDK: `34`
* OpenJDK: `17`
* nodeJS: `20`
