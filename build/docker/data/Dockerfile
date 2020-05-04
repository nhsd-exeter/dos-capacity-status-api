FROM nhsd/postgres:20200427

COPY assets/ /

RUN set -ex && \
    \
    find /sql -type d -exec chmod 777 {} \; && \
    find /sql -type f -exec chmod 666 {} \;
