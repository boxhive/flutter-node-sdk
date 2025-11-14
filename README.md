# Boxhive - Flutter SDK and NodeJS Docker image
[![Docker Image Version](https://img.shields.io/docker/v/boxhive/flutter-sdk-node)](https://hub.docker.com/repository/docker/boxhive/flutter-sdk-node)

[![Docker Pulls](https://img.shields.io/docker/pulls/boxhive/flutter-sdk-node)](https://hub.docker.com/repository/docker/boxhive/flutter-sdk-node)
[![Docker Stars](https://img.shields.io/docker/stars/boxhive/flutter-sdk-node)](https://hub.docker.com/repository/docker/boxhive/flutter-sdk-node)
[![Docker Size](https://img.shields.io/docker/image-size/boxhive/flutter-sdk-node/main)](https://hub.docker.com/repository/docker/boxhive/flutter-sdk-node)

Docker image built with Android SDK, Flutter SDK and nodeJS to handle NX monorepos containing both frontend, backend and flutter mobile apps.

## Image tools versions

* Flutter SDK: `3.38.0`
* Android SDK: `36` (`>= 34` available)
* OpenJDK: `21`
* Gradle: `8.13`
* nodeJS: `20`

## Versions

From version `3.27.1`, versioning will differ from flutter one and use a combination of JDK, flutter SDK, and semantic version.

Example: 
```
21-3.27.1-0
```

Where:
* `21`: refer to JDK
* `3.27.1`: refers to Flutter SDK
* `0`: refers to semantic version associated with the current image version

If a fix occurs without changing JDK or SDK version, only the last part will be bumped.

*Note*: Default installed gradle version has not a big impact on image behavior since gradle version can be changed through project properties.

## Usage

Use this image in gitlab-ci or any other CI you need.

```yaml
image: boxhive/flutter-sdk-node:latest
```
