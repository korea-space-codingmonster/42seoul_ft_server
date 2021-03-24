FROM debian:buster
LABEL maintainer="napark <napark.student.42seoul.kr>"

#init arg
#변수값
ARG WP_DB_NAME = wordpress
ARG WP_DB_USER = napark
ARG WP_DB_PASSWORD = 42seoul

#docker 이미지 포트를 정할 때 쓰는 명령어
EXPOSE 80/tcp 443/tcp

#-y를 넣는 이유 : yes명령어를 써야할 때 스킵하기 위해
RUN apt-get update -y; apt upgrade -y

#install dependency
RUN apt install ngninx php-fpm mariadb-server php-mysql php-mbstring vim curl -y


#copy to src files
COPY srcs /

RUN openssl genrsa -out ft_server.localhost.key 4096; \
        openssl req -x509 -nodes -days 365 \
        -key ft_server.localhost.key \
        -out ft_server.localhost.crt \
        -subj "/C=KR/ST=SEOUL/L=Gaepo-dong/O=42Seoul/OU=jaeskim/CN=localhost"; \
        chmod 644 ft_server.localhost.*; \
        mv ft_server.localhost.crt /etc/ssl/certs/;	\
	    mv ft_server.localhost.key /etc/ssl/private/; \
	    cp /nginx-sites-available-default.conf /etc/nginx/sites-available/default

# setup mysqlDB(mariaDB)
RUN service mysql start; \
	    mysql -e "CREATE DATABASE ${WP_DB_NAME};\
	    USE ${WP_DB_NAME}; \
	    CREATE USER '${WP_DB_USER}'@'localhost' IDENTIFIED BY '${WP_DB_PASSWORD}'; \
	    GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${WP_DB_USER}'@'localhost' WITH GRANT OPTION; \
	    FLUSH PRIVILEGES;"

# chage directory owner
RUN chown -R www-data:www-data /var/www/html/

# setup nginx running forground
# RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

ENTRYPOINT ["/bin/bash", "-C", "/server.sh"]
