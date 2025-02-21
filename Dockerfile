FROM ubuntu:24.04

LABEL maintainer="boxhive"

# Define default Flutter versions per architecture
ARG FLUTTER_SDK_VERSION=3.29.0

# Buildx automatically sets TARGETARCH (e.g., "amd64" or "arm64")
ARG TARGETARCH

# Environment variables
ENV HOME=/home/mobiledevops
ENV ANDROID_HOME="/opt/android-sdk-linux"
ENV ANDROID_SDK_ROOT=$ANDROID_HOME
ENV FLUTTER_HOME="/home/mobiledevops/flutter"
ENV GEM_HOME="$HOME/.gems"
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8

# Update PATH
ENV PATH=$ANDROID_HOME/cmdline-tools:$ANDROID_HOME/cmdline-tools/bin:$ANDROID_HOME/platform-tools:$FLUTTER_HOME/bin:$GEM_HOME/bin:$PATH

# Set user
RUN groupadd mobiledevops \
    && useradd -g mobiledevops --create-home --shell /bin/bash mobiledevops

# Install base packages
RUN apt-get -qq update \
    && apt-get -qqy --no-install-recommends install \
         ruby-full xz-utils apt-utils build-essential \
         openjdk-21-jdk openjdk-21-jre-headless \
         software-properties-common libssl-dev libffi-dev \
         python3-dev \
         cargo pkg-config libstdc++6 \
         libpulse0 libglu1-mesa openssh-server zip unzip curl lldb git \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash \
    && apt-get -qq update \
    && apt-get -qqy --no-install-recommends install nodejs \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && corepack enable && \
    mkdir -p /home/mobiledevops/.cache/yarn

# Download and unzip Android SDK Tools
ARG ANDROID_SDK_TOOLS_VERSION=11076708
ARG ANDROID_SDK_TOOLS_CHECKSUM=2d2d50857e4eb553af5a6dc3ad507a17adf43d115264b1afc116f95c92e5e258
RUN curl -s https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip > /tools.zip \
    && echo "$ANDROID_SDK_TOOLS_CHECKSUM  /tools.zip" | sha256sum -c - \
    && unzip -qq /tools.zip -d $ANDROID_HOME \
    && rm /tools.zip

# Create directories for Android and app
RUN mkdir -p /home/mobiledevops/.android /home/mobiledevops/app \
    && touch /home/mobiledevops/.android/repositories.cfg

WORKDIR $HOME/app

# Install SDKMAN and update sdkmanager (licenses and updates)
RUN curl -s "https://get.sdkman.io" | bash
SHELL ["/bin/bash", "-c"]   
RUN yes | $ANDROID_HOME/cmdline-tools/bin/sdkmanager --licenses --sdk_root=${ANDROID_SDK_ROOT} \
    && $ANDROID_HOME/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --update \
    && $ANDROID_HOME/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} \
         "build-tools;35.0.0" "build-tools;34.0.0" "platforms;android-35" "platforms;android-34" \
         "platform-tools" "extras;android;m2repository" "extras;google;google_play_services" \
         "extras;google;m2repository" "add-ons;addon-google_apis-google-24" "cmdline-tools;latest"

# Install Gradle via SDKMAN
ARG GRADLE_VERSION=8.9
RUN source "${HOME}/.sdkman/bin/sdkman-init.sh" && sdk install gradle ${GRADLE_VERSION}

# Set permissions and switch to user
RUN chown -R mobiledevops:mobiledevops /home/mobiledevops
USER mobiledevops

# Install bundler (Ruby)
RUN gem install bundler

# Install and configure Flutter
WORKDIR $HOME

# Conditionally download and extract Flutter based on TARGETARCH
RUN if [ "$TARGETARCH" = "arm64" ]; then \
      echo "Downloading Flutter for ARM64"; \
      curl --fail --remote-time --location -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_${FLUTTER_SDK_VERSION}-stable.zip && \
      unzip flutter_macos_arm64_${FLUTTER_SDK_VERSION}-stable.zip -d . && \
      rm flutter_macos_arm64_${FLUTTER_SDK_VERSION}-stable.zip; \
    else \
      echo "Downloading Flutter for AMD64"; \
      curl --fail --remote-time --location -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_SDK_VERSION}-stable.tar.xz && \
      tar xf flutter_linux_${FLUTTER_SDK_VERSION}-stable.tar.xz && \
      rm flutter_linux_${FLUTTER_SDK_VERSION}-stable.tar.xz; \
    fi

WORKDIR $FLUTTER_HOME

# Final Flutter setup
RUN dart --disable-analytics && \
    flutter config --no-cli-animations --no-analytics && \
    flutter precache && \
    flutter doctor --android-licenses
