FROM mobiledevops/android-sdk-image:34.0.0-jdk17

USER root

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sh && \
    apt-get update && \
    apt-get install -y nodejs \
    ruby-full \
    curl \
    snapd \
    unzip \
    xz-utils \
    zip \
    git \
    clang \
    cmake \
    ninja-build \
    libgtk-3-dev

USER mobiledevops

WORKDIR /home/mobiledevops/dev

ARG FLUTTER_SDK_VERSION=3.19.0

RUN curl https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_SDK_VERSION}-stable.tar.xz -O && \
    tar xf flutter_linux_${FLUTTER_SDK_VERSION}-stable.tar.xz && \
    rm flutter_linux_${FLUTTER_SDK_VERSION}-stable.tar.xz

WORKDIR /home/mobiledevops/app

ENV PATH="/home/mobiledevops/dev/flutter/bin:$PATH"

RUN sdkmanager --sdk_root=$ANDROID_SDK_ROOT --install "cmdline-tools;latest" && \
    dart --disable-analytics && \
    flutter config --no-cli-animations && \
    flutter precache && \
    flutter doctor --android-licenses
