FROM nginx:latest

COPY assets/certificate/certificate.key /certificate/certificate.key
COPY assets/certificate/certificate.pem /certificate/certificate.pem
COPY assets/etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY assets/var/www/capacity-status-api/static/ /var/www/capacity-status-api/static

EXPOSE 443

CMD exec nginx -g 'daemon off;'
