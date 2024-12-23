# Boxhive - Flutter SDK and NodeJS Docker image
[![Docker Image Version](https://img.shields.io/docker/v/boxhive/flutter-sdk-node)](https://hub.docker.com/repository/docker/boxhive/flutter-sdk-node)

[![Docker Pulls](https://img.shields.io/docker/pulls/boxhive/flutter-sdk-node)](https://hub.docker.com/repository/docker/boxhive/flutter-sdk-node)
[![Docker Stars](https://img.shields.io/docker/stars/boxhive/flutter-sdk-node)](https://hub.docker.com/repository/docker/boxhive/flutter-sdk-node)
[![Docker Size](https://img.shields.io/docker/image-size/boxhive/flutter-sdk-node/main)](https://hub.docker.com/repository/docker/boxhive/flutter-sdk-node)

Docker image built with Android SDK, Flutter SDK and nodeJS to handle NX monorepos containing both frontend, backend and flutter mobile apps.

## Versions

From 3.27.1 versions will differ from flutter version and become a combination of JDK and Flutter.

Example: `21-3.27.1`

## Usage

Use this image in gitlab-ci or any other CI you need.

```yaml
image: boxhive/flutter-sdk-node:latest
```

## Image tools versions

* Flutter SDK: `3.27.1`
* Android SDK: `35`
* OpenJDK: `21`
* Gradle: `8.9`
* nodeJS: `20`
