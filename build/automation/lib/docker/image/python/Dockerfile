FROM python:latest as base

# ==============================================================================

FROM base as builder
ENV \
    GOSU_VERSION="1.12"

RUN set -eux && \
    \
    # Get base packages
    apk add --no-cache \
        ca-certificates \
        dpkg \
        gnupg \
        wget \
    && \
    \
    # Get gosu
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" && \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu && \
    gpgconf --kill all && \
    rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc && \
    chmod +x /usr/local/bin/gosu

# ==============================================================================

FROM base
ENV \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    PYTHONDONTWRITEBYTECODE="1" \
    PYTHONUNBUFFERED="1" \
    SYSTEM_USER_GID="999" \
    SYSTEM_USER_UID="999" \
    SYSTEM_USER="python" \
    TZ="UTC"

COPY --from=builder /usr/local/bin/gosu /usr/local/bin/gosu
COPY assets/ /
RUN set -eux && \
    \
    # Install base packages
    apk add --no-cache \
        bash \
        curl \
    && \
    \
    # Configure system user
    ( deluser $SYSTEM_USER ||: ) && ( delgroup $SYSTEM_USER ||: ) && ( delgroup $(getent group $SYSTEM_USER_GID | sed -e "s/:x:$SYSTEM_USER_GID//g") ||: ) && \
    addgroup -S -g $SYSTEM_USER_GID $SYSTEM_USER && \
    adduser -H -D -s /bin/false -g "" -h /tmp -G $SYSTEM_USER -u $SYSTEM_USER_UID $SYSTEM_USER && \
    gosu nobody true

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
