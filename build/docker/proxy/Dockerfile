FROM nginx:1.19.0

COPY assets/ /

WORKDIR /application
EXPOSE 443
ENTRYPOINT [ "/sbin/entrypoint.sh" ]
