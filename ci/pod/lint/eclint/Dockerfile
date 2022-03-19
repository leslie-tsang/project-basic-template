# Dockerfile - eclint

ARG ENV_BASIC_IMAGE
ARG ENV_BASIC_IMAGE_TAG

FROM ${ENV_BASIC_IMAGE}:${ENV_BASIC_IMAGE_TAG}

WORKDIR /root

RUN npm install --location=global eclint
