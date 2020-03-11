#FROM python:3.7

#RUN apt-get update && apt-get install -y build-essential && apt-get install -y python-dev && apt-get install -y python3-setuptools && apt install -y python3-psycopg2



FROM python:latest

#RUN mkdir -p /application
#COPY assets/* /application/
#COPY ${APP_JAR} ${APP_HOME}/

ENV DEBIAN_FRONTEND="noninteractive"

ADD assets/api-app.tar.gz /application
ADD assets/certificate /certificate

#RUN pip install -r /application/requirements.txt

RUN set -ex && \
    \
    # Install base packages
    echo "APT::Install-Recommends 0;\nAPT::Install-Suggests 0;" > /etc/apt/apt.conf.d/99config && \
    apt-get --yes update && \
    apt-get --yes upgrade && \
    apt-get --yes install \
        gcc \
        libpq-dev \
        python3-psycopg2 \
        musl \
        postgresql-11-debversion \
        postgresql-client \
        postgresql-server-dev-11 \
        python3-gunicorn\
        python3-dev \
    && \
    \
    # Clean up
    #ln -s /lib/x86_64-linux-musl/libc.so usr/lib/libc.musl-x86_64.so.1 \
    ln -s /lib/x86_64-linux-musl/libc.so /lib/ld.musl-x86_64.so.1 && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

EXPOSE 8443

CMD cd /application && pip install -r requirements.txt && sleep 1000000s

#&& python manage.py collectstatic --noinput && gunicorn --bind 0.0.0.0:8443 --certfile /certificate/localhost.crt --keyfile /certificate/localhost.key --ssl-version 5 api.wsgi
