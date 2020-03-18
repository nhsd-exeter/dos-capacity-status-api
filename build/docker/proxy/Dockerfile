FROM nginx:1.17.9

COPY assets/nginx.conf /etc/nginx/nginx.conf
COPY assets/certificate/localhost.key /etc/nginx/localhost.key
COPY assets/certificate/localhost.pem /etc/nginx/localhost.pem

EXPOSE 8060
EXPOSE 443

CMD exec nginx -g 'daemon off;'
