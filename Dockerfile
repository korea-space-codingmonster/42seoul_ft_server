#이미지 만들기 시작
FROM debian:buster
LABEL maintainer="napark <napark.student.42seoul.kr>"

#init arg
#변수값
ARG WP_DB_NAME=wordpress
ARG WP_DB_USER=napark
ARG WP_DB_PASSWORD=42seoul

#docker 이미지 포트를 정할 때 쓰는 명령어
EXPOSE 80/tcp 443/tcp

#-y를 넣는 이유 : yes명령어를 써야할 때 스킵하기 위해
RUN			apt-get update -y; apt upgrade -y

#install dependency
RUN			apt install nginx php-fpm mariadb-server php-mysql php-mbstring vim curl -y

#copy to src files
COPY		./srcs/* ./

RUN		openssl req -newkey rsa:4096 -days 365 -nodes -x509\
				-subj "/C=KR/ST=SEOUL/L=Gaepo-dong/O=42Seoul/OU=yjung/CN=localhost"\
				-keyout localhost.dev.key -out localhost.dev.crt; \
				mv localhost.dev.crt /etc/ssl/certs/;	\
				mv localhost.dev.key /etc/ssl/private/; \
				chmod 600 etc/ssl/certs/localhost.dev.crt etc/ssl/private/localhost.dev.key; \
				cp /default /etc/nginx/sites-available/default

RUN		curl -O https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz
RUN		tar -xzf phpMyAdmin-5.0.4-all-languages.tar.gz -C /var/www/html/; \
			mv /var/www/html/phpMyAdmin-5.0.4-all-languages /var/www/html/phpmyadmin; \
			mv /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php

RUN		service mysql start; \
			mysql -e "CREATE DATABASE ${WP_DB_NAME};\
			USE ${WP_DB_NAME}; \
			CREATE USER '${WP_DB_USER}'@'localhost' IDENTIFIED BY '${WP_DB_PASSWORD}'; \
			GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${WP_DB_USER}'@'localhost' WITH GRANT OPTION; \
			FLUSH PRIVILEGES;" 

#setup wordpress
RUN		tar	-xzf wordpress.tar.gz -C /var/www/html/; \
			mv /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php; \
			sed -i "s/database_name_here/${WP_DB_NAME}/g" /var/www/html/wordpress/wp-config.php; \
			sed -i "s/username_here/${WP_DB_USER}/g" /var/www/html/wordpress/wp-config.php; \
			sed -i "s/password_here/${WP_DB_PASSWORD}/g" /var/www/html/wordpress/wp-config.php

RUN 		chown -R www-data:www-data /var/www/html/

ENTRYPOINT ["/bin/bash", "-C", "/run.sh"]
