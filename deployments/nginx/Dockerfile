FROM nginx:latest

COPY deployments/nginx/nginx.conf /etc/nginx/nginx.conf
COPY deployments/nginx/certs /etc/nginx/certs/
COPY deployments/nginx/.htpasswd /etc/nginx/.htpasswd

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]