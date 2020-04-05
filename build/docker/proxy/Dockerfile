FROM nginx:latest

COPY assets/ /

WORKDIR /application
EXPOSE 443
ENTRYPOINT [ "/sbin/entrypoint.sh" ]
