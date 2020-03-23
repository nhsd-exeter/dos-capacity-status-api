docker build -t custom-nginx .
docker run -p 8060:8060 -p 443:443 --name my-custom-nginx-container -d custom-nginx
