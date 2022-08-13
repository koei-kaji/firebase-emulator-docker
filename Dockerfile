# https://firebase.google.com/docs/emulator-suite/install_and_configure
FROM node:16.15.1-alpine3.16
ARG NPM_VERSION=8.13.2
ARG FIREBASE_TOOLS_VERSION=11.1.0
ENV USERNAME=firebase
WORKDIR /usr/firebase
RUN apk update && apk add --no-cache \
    # https://pkgs.alpinelinux.org/packages
    openjdk11-jre-headless=11.0.16_p8-r0 \
    bash=5.1.16-r2 \
    # >>> update for vulnerabilities
    libcrypto1.1=1.1.1q-r0 \
    libssl1.1=1.1.1q-r0 \
    zlib=1.2.12-r3 \
    # <<< update for vulnerabilities
    && npm install --location=global npm@${NPM_VERSION} \
    && npm install -g \
    firebase-tools@${FIREBASE_TOOLS_VERSION} \
    && rm -rf /var/cache/apk/* \
    && npm cache clean --force \
    && addgroup -S ${USERNAME} && adduser -S ${USERNAME} -G ${USERNAME} \
    && chown -R ${USERNAME}:${USERNAME} .
USER ${USERNAME}:${USERNAME}
COPY . ./
ENV PROJECT=dummy
# hadolint ignore=DL3025
CMD firebase emulators:start --project ${PROJECT}