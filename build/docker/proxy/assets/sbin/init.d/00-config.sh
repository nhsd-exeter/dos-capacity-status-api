#!/bin/bash
set -e

cp -fv /etc/nginx/nginx.conf.template /etc/nginx/nginx.conf

sed -i "s;API_HOST_TO_REPLACE;${API_HOST//&/\\&};g" /etc/nginx/nginx.conf
