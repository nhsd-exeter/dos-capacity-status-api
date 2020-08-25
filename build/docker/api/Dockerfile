FROM python:latest

ENV DEBIAN_FRONTEND="noninteractive"


EXPOSE 8443

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

ADD assets/api-app.tar.gz /application
RUN mkdir application/static
COPY assets/certificate /certificate

WORKDIR /application

RUN set -ex && \
    apk add --no-cache postgresql-libs && \
    apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev && \
    \
    pip install --upgrade pip && \
    pip install -r requirements.txt && \
    pip install gunicorn==20.0.4

CMD python manage.py migrate && \
    python manage.py collectstatic --noinput && \
    gunicorn -w 8 --bind 0.0.0.0:8443 --certfile /certificate/certificate.crt --keyfile /certificate/certificate.key --ssl-version 5 api.wsgi
