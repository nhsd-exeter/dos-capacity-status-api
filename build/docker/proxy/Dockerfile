FROM nginx:latest

COPY assets/certificate/certificate.key /certificate/certificate.key
COPY assets/certificate/certificate.pem /certificate/certificate.pem
COPY assets/etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY assets/application/static /application/static

EXPOSE 443

CMD exec nginx -g 'daemon off;'
