FROM alpine:3.8

RUN apk upgrade --update && \
    apk add \
        bash \
        tini \
        su-exec \
        curl

ARG JAVA_DISTRIBUTION=jre
ARG JAVA_MAJOR_VERSION=8
ARG JAVA_UPDATE_VERSION=latest
ARG JAVA_BUILD_NUMBER=
ARG JAVA_HASH=
ARG BUILD_DATE=undefined

RUN if  [ "${JAVA_DISTRIBUTION}" = "jre" ]; \
      then export JAVA_PACKAGE_POSTFIX_VERSION=-jre ; \
      else export JAVA_PACKAGE_POSTFIX_VERSION= ; \
    fi && \
    export JAVA_VERSION=${JAVA_MAJOR_VERSION}.${JAVA_UPDATE_VERSION}.${JAVA_BUILD_NUMBER} && \
    if  [ "${JAVA_UPDATE_VERSION}" = "latest" ]; \
      then apk add --update openjdk${JAVA_MAJOR_VERSION}${JAVA_PACKAGE_POSTFIX_VERSION} ; \
      else apk add --update "openjdk${JAVA_MAJOR_VERSION}${JAVA_PACKAGE_POSTFIX_VERSION}=${JAVA_VERSION}" ; \
    fi && \
    # Clean caches and tmps
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    rm -rf /var/log/*

ENV JAVA_HOME=/usr/lib/jvm/default-jvm
ENV PATH=$JAVA_HOME/bin:$PATH
