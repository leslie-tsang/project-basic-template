# Dockerfile - spellcheck

ARG ENV_BASIC_IMAGE
ARG ENV_BASIC_IMAGE_TAG

FROM ${ENV_BASIC_IMAGE}:${ENV_BASIC_IMAGE_TAG}

WORKDIR /root

RUN apk add git python3 py3-pip \
 && apk cache clean \
 && pip install --break-system-packages codespell==2.1.0
