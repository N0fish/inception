FROM debian:stable

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    php php-fpm php-mysql php-cli php-curl php-gd php-mbstring php-xml php-zip \
    mariadb-client \
    curl unzip wget \
    && apt-get clean

# wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# WordPress
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

RUN curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    cp -r wordpress/* . && \
    rm -rf wordpress latest.tar.gz

RUN chown -R www-data:www-data /var/www/html
RUN ln -s /usr/sbin/php-fpm8.2 /usr/sbin/php-fpm

RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/*/fpm/pool.d/www.conf

EXPOSE 9000

COPY wp-config-create.sh /wp-config-create.sh
RUN chmod +x /wp-config-create.sh

ENTRYPOINT ["/wp-config-create.sh"]
# # Pour gerer le probleme du PID 1, on utilise exec pour etre sur que php-fpm soit bien le PID 1
# CMD exec php-fpm -F || exit 1
CMD ["php-fpm", "-F"]
