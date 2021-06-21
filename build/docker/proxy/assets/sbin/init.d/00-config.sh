#!/bin/bash
set -e

cp -fv /etc/nginx/nginx.conf.template /etc/nginx/nginx.conf

sed -i "s;API_HOST_TO_REPLACE;${API_HOST//&/\\&};g" /etc/nginx/nginx.conf
sed -i "s;REQ_PER_SEC_PROXY_THROTTLE_TO_REPLACE;${REQ_PER_SEC_PROXY_THROTTLE};g" /etc/nginx/nginx.conf

allowed_host_list=${API_ADMIN_ALLOWED_HOSTS}
allowed_hosts=

IFS=","
for allowed_host in $allowed_host_list; do
    allowed_hosts+="$allowed_host 1\;"
done

sed -i "s;ALLOWED_HOSTS_TO_REPLACE;${allowed_hosts//&/\\&};g" /etc/nginx/nginx.conf
