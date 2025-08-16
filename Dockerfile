FROM ubuntu:24.04

# Based on original work from https://github.com/mobiledevops/android-sdk-image
LABEL maintainer="boxhive"

ARG FLUTTER_SDK_VERSION=3.32.8

# Command line tools only
# https://developer.android.com/studio/index.html
ENV ANDROID_SDK_TOOLS_VERSION=11076708
ENV ANDROID_SDK_TOOLS_CHECKSUM=2d2d50857e4eb553af5a6dc3ad507a17adf43d115264b1afc116f95c92e5e258

ENV GRADLE_VERSION=8.10

ENV HOME=/home/mobiledevops
ENV ANDROID_HOME="/opt/android-sdk-linux"
ENV ANDROID_SDK_ROOT=$ANDROID_HOME
ENV FLUTTER_HOME="/home/mobiledevops/.flutter-sdk"
ENV GEM_HOME="$HOME/.gems"

ENV PATH=$ANDROID_HOME/cmdline-tools:$ANDROID_HOME/cmdline-tools/bin:$ANDROID_HOME/platform-tools:$FLUTTER_HOME/bin:$GEM_HOME/bin:$PATH

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8

# Set user
RUN groupadd mobiledevops \
    && useradd -g mobiledevops --create-home --shell /bin/bash mobiledevops

# Add base environment
RUN apt-get -qq update \
    && apt-get -qqy --no-install-recommends install \
    ruby-full \
    xz-utils \
    apt-utils \
    build-essential \
    openjdk-21-jdk \
    openjdk-21-jre-headless \
    software-properties-common \
    libssl-dev \
    libffi-dev \
    python3-dev \
    cargo \
    pkg-config\  
    libstdc++6 \
    libpulse0 \
    libglu1-mesa \
    openssh-server \
    zip \
    unzip \
    curl \
    lldb \
    git > /dev/null \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sh \ 
    && apt-get -qq update \
    && apt-get -qqy --no-install-recommends install \
    nodejs > /dev/null \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && corepack enable && \
    mkdir -p /home/mobiledevops/.cache/yarn

# Download and unzip Android SDK Tools
RUN curl -s https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip > /tools.zip \
    && echo "$ANDROID_SDK_TOOLS_CHECKSUM ./tools.zip" | sha256sum -c \
    && unzip -qq /tools.zip -d $ANDROID_HOME \
    && rm -v /tools.zip

# Add folder for SDK files 
RUN mkdir -p /home/mobiledevops/.android \
    && mkdir -p /home/mobiledevops/app \
    && touch /home/mobiledevops/.android/repositories.cfg

WORKDIR $HOME/app

# Install SDKMAN
RUN curl -s "https://get.sdkman.io" | bash
SHELL ["/bin/bash", "-c"]   

# Update sdkmanager
RUN yes | $ANDROID_HOME/cmdline-tools/bin/sdkmanager --licenses --sdk_root=${ANDROID_SDK_ROOT} \ 
    && $ANDROID_HOME/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --update \
    && $ANDROID_HOME/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} \
    "build-tools;36.0.0" \
    "build-tools;35.0.0" \
    "build-tools;34.0.0" \
    "build-tools;33.0.3" \
    "build-tools;32.0.0" \
    "build-tools;31.0.0" \
    "build-tools;30.0.1" \
    "platforms;android-36" \
    "platforms;android-35" \
    "platforms;android-34" \
    "platforms;android-33" \
    "platforms;android-32" \
    "platforms;android-31" \
    "platforms;android-30" \
    "platform-tools" \
    "extras;android;m2repository" \
    "extras;google;google_play_services" \
    "extras;google;m2repository" \
    "add-ons;addon-google_apis-google-24" \
    "cmdline-tools;latest"

# Install Gradle
RUN source "${HOME}/.sdkman/bin/sdkman-init.sh" \
    && sdk install gradle ${GRADLE_VERSION}

# Set user
RUN chown -R mobiledevops:mobiledevops /home/mobiledevops
USER mobiledevops

# Ruby and bundler setup
RUN gem install bundler

# Install and configure flutter
RUN mkdir $FLUTTER_HOME \
    && cd $FLUTTER_HOME \
    && curl --fail --remote-time --location -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_SDK_VERSION}-stable.tar.xz \
    && tar xf flutter_linux_${FLUTTER_SDK_VERSION}-stable.tar.xz --strip-components=1 \
    && rm flutter_linux_${FLUTTER_SDK_VERSION}-stable.tar.xz

RUN dart --disable-analytics && \
    flutter config --no-cli-animations --no-analytics && \
    flutter precache && \
    flutter doctor --android-licenses
