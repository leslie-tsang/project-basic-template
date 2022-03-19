# Dockerfile - release

ARG ENV_BASIC_IMAGE
ARG ENV_BASIC_IMAGE_TAG

FROM ${ENV_BASIC_IMAGE}:${ENV_BASIC_IMAGE_TAG}

WORKDIR /root

COPY pod/build/release/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

RUN ["/entrypoint.sh", "__env_init"]
