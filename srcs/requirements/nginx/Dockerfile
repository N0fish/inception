FROM debian:stable

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt install -y nginx openssl && apt-get clean 
RUN mkdir -p /var/www/html

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/algultse.key \
    -out /etc/ssl/certs/algultse.crt \
    -subj "/C=FR/ST=Paris/L=Paris/O=42/CN=algultse.42.fr"

RUN openssl dhparam -out /etc/nginx/dhparam.pem 2048

RUN rm /etc/nginx/sites-enabled/default

COPY default.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /var/www/html

EXPOSE 443

# Pas de probleme de PID 1 ici, nginx est le PID 1
CMD ["nginx", "-g", "daemon off;"]
