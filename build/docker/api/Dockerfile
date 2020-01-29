FROM python:latest

# TODO: ADD assets/api.tar.gz /application

RUN set -ex && \
    \
    # Install base packages
    apk add --update \
        gcc \
        libpq \
        musl-dev \
        postgresql-dev \
        py-gunicorn \
        python3-dev \
    && \
    \
    # Clean up
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*
