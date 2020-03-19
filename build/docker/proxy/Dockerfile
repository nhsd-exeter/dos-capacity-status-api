FROM nginx:latest

COPY assets/certificate/localhost.key /certificate/localhost.key
COPY assets/certificate/localhost.pem /certificate/localhost.pem
COPY assets/etc/nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 8060
EXPOSE 443

CMD exec nginx -g 'daemon off;'
