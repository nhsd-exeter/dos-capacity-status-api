FROM python:3.8.2-slim

ENV DEBIAN_FRONTEND="noninteractive"

RUN set -ex && \
    \
    # Install base packages
    echo "APT::Install-Recommends 0;\nAPT::Install-Suggests 0;" > /etc/apt/apt.conf.d/99config && \
    apt-get --yes update && \
    apt-get --yes upgrade && \
    apt-get --yes install \
        gcc \
        libpq-dev \
        python3-dev \
    && \
    \
    # Clean up
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* /var/cache/apt/*

EXPOSE 8443

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

ADD assets/api-app.tar.gz /application
COPY assets/certificate /certificate

WORKDIR /application

RUN set -ex && \
    \
    pip install --upgrade pip && \
    pip install -r requirements.txt && \
    pip install gunicorn==20.0.4

CMD python manage.py migrate && \
    python manage.py collectstatic --noinput && \
    gunicorn -w 8 --bind 0.0.0.0:8443 --certfile /certificate/certificate.crt --keyfile /certificate/certificate.key --ssl-version 5 api.wsgi
