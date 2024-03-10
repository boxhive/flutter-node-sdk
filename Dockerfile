FROM mobiledevops/android-sdk-image:34.0.0-jdk17

ARG FLUTTER_SDK_VERSION=3.19.3

ENV FLUTTER_HOME "/home/mobiledevops/.flutter-sdk"
ENV PATH $PATH:$FLUTTER_HOME/bin

USER root

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sh && \
    apt-get update && \
    apt-get install -y nodejs \
    ruby-full \
    curl \
    unzip \
    xz-utils \
    zip \
    git

RUN corepack enable && \
    mkdir -p /home/mobiledevops/.cache/yarn && \
    chown -R mobiledevops:mobiledevops /home/mobiledevops/.cache

USER mobiledevops

RUN mkdir $FLUTTER_HOME \
    && cd $FLUTTER_HOME \
    && curl --fail --remote-time --location -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_SDK_VERSION}-stable.tar.xz \
    && tar xf flutter_linux_${FLUTTER_SDK_VERSION}-stable.tar.xz --strip-components=1 \
    && rm flutter_linux_${FLUTTER_SDK_VERSION}-stable.tar.xz

RUN sdkmanager --sdk_root=$ANDROID_SDK_ROOT --install "cmdline-tools;latest" && \
    dart --disable-analytics && \
    flutter config --no-cli-animations && \
    flutter config --no-analytics && \
    flutter precache && \
    flutter doctor --android-licenses
