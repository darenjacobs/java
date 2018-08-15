FROM darenjacobs/alpine:3.8

ARG JAVA_DISTRIBUTION=jre
ARG JAVA_MAJOR_VERSION=8
ARG JAVA_UPDATE_VERSION=latest
ARG JAVA_BUILD_NUMBER=

RUN if  [ "${JAVA_DISTRIBUTION}" = "jre" ]; \
      then export JAVA_PACKAGE_POSTFIX_VERSION=-jre ; \
      else export JAVA_PACKAGE_POSTFIX_VERSION= ; \
    fi && \
    export JAVA_VERSION=${JAVA_MAJOR_VERSION}.${JAVA_UPDATE_VERSION}.${JAVA_BUILD_NUMBER} && \
    if  [ "${JAVA_UPDATE_VERSION}" = "latest" ]; \
      then apk add --update openjdk${JAVA_MAJOR_VERSION}${JAVA_PACKAGE_POSTFIX_VERSION} ; \
      else apk add --update "openjdk${JAVA_MAJOR_VERSION}${JAVA_PACKAGE_POSTFIX_VERSION}=${JAVA_VERSION}" ; \
    fi && \
    # Install latest glibc
    wget --directory-prefix=/tmp https://github.com/andyshinn/alpine-pkg-glibc/releases/download/2.22-r8/glibc-2.22-r8.apk && \
    apk add --allow-untrusted /tmp/glibc-2.22-r8.apk && \
    wget --directory-prefix=/tmp https://github.com/andyshinn/alpine-pkg-glibc/releases/download/2.22-r8/glibc-bin-2.22-r8.apk && \
    apk add --allow-untrusted /tmp/glibc-bin-2.22-r8.apk && \
    # Clean caches and tmps
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    rm -rf /var/log/*

ENV JAVA_HOME=/usr/lib/jvm/default-jvm
ENV PATH=$JAVA_HOME/bin:$PATH
