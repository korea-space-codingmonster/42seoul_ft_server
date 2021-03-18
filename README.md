# 42seoul_ft_server


<ft_server 서브젝트>

ft_server는 [서브젝트 관리]에 관한 프로젝트 입니다. docker를 이해하고 (프로젝트에서는 docker 컴포즈는 사용안함, 도커파일만 사용), 첫 웹 서버를 설정하게 됩니다.

<소개>
- 이 서브젝트는 시스템 관리를 소개합니다.
- 이는 스크립트를 사용하여 작업을 자동화하는 것의 중요성을 알려준다. 이를 위해, 당신은 “docker”기술을 이해하고 이를 이용해 완전한 웹 서버를 설치합니다.
- 이 서버는 동시에 여러 서비스를 실행할 것입니다. : wordpress, phpmyadmin, sql database


chapter 2
Common instruction

	- ./srcs/서버_구성에_필요한_모든_파일_넣기
	- ./srcs/워드프레스_웹사이트에_필요한_모든_파일_넣기
	- ./dockerfile
		-도커파일이 당신의 컨테이너를 빌드할 것입니다. Docker compose는 사용 금지


Chapter3

Mandatory part(필수파트)

- 딱 하나의 도커 컨테이너에 nginx가 있는 웹 서버를 설정해야합니다. 컨테이너 os는 꼭 debian buster여야 합니다.
- 웹 서버는 여러 서비스를 동시에 실행할 수 있어야 합니다.
    - 그 서비스들은 wordpress 웹사이트, phpmyadmin, mysql 입니다.
    - Sql 데이터베이스가 wordpress 및 phpmyadmin과 작동하는지 확인해야합니다.




요약

	| 워드프레스 | phpmyadmin  | -------------- |
	| ------- MYSQL ------  | -- 다른 도커 --- |
	| 엔진엑스 (오토인덱스, SSL) | --- 컨테이너 --- |      
	|   데비안 OS 버스터 버전   | ---------------| 
	| ---------------- 도커 ------------------| 
	| ----- 내 컴퓨터(맥 OS 모하비 10.14.6) -----|
	


다시 요약

LEMP 스택 + 워드프레스 + SSL, 오토인덱스 옵션이 있는 도커 컨테이너를 만드시오!

-LEMP 스택
	- 동적 웹 어플리케이션을 구현하기 위해서 필요한 LINUX + NGINX + MYSQL(or MariaDB) + PHP(or Peerl, Python)를 모아서 부르는 말이다.
	
- LAMP 스택
	- Linux + Apache + MySQL(or MariaDB) + PHP(or Perl, Python)



즉, 이 서브젝트에 대해 다시 말하면
도커 기술을 활용하여 웹 서버를 만드는 것입니다. 만든 웹서버는 충족시켜야할 조건이 있는데 다음과 같습니다.

1. 웹서버는 Nginx를 이용해서 설치하며, 하나의 도커 컨테이너만 설치합니다. 이 컨테이너의 os는 데비안 버스터 입니다.
2.웹 서버는 여러 서비스가 연동되어야 하는데 서비스 목록은 다음과 같습니다. wordpress웹사이트, phpMyAdmin, MySQL
mysql은 워드프로세스에서 연동하여 사용이 가능하여야 한다.
3. 우리가 만드는 서버는 SSL프로토콜을 사용할 수 있어야 합니다.
4. url에 따라서 정확한 웹사이트와 연결될 수 있도록 처리해야합니다.
5. 언제든 해체할 수 있는 autoindex가 적용되어햐 합니다.


위 요구사항을 알아보고 구현해 보자!

***
## ft_server를 수행하는데 필요한 개념들

1. Docker에 대한 이해 [https://github.com/korea-space-codingmonster/42seoul_ft_server/wiki/Docker-설치]
2. docker 사용법 [https://github.com/korea-space-codingmonster/42seoul_ft_server/wiki/도커-사용법]
3. ft_server 관련 소프트웨어 정리 [https://github.com/korea-space-codingmonster/42seoul_ft_server/wiki/ft_server-관련-소프트웨어-정리]
4. 과제 수행과정 [https://github.com/korea-space-codingmonster/42seoul_ft_server/wiki/과제-수행-과정]



1. 도커 설치 및 주요 명령어 확인

Docker Desktop for Mac에서 Stable 버전 설치

설치가 완료되면 상단바에 고래 아이콘 등장한다. 도커가 실행중이라는 의미, 즉 터미널에서 도커 접근 가능.

도커 명령어 모음

컨테이너 조회 (실행 중, 중지된 것까지 포함)

docker ps -a
컨테이너 중지

docker stop <컨테이너 이름 혹은 아이디>
컨테이너 시작 (중지 된 컨테이너 시작) 및 재시작 (실행 중인 컨테이너 재부팅)

docker start <컨테이너 이름 혹은 아이디>
docker restart <컨테이너 이름 혹은 아이디>
컨테이너 접속 (실행중인 컨테이너에 접속)

docker attach <컨테이너 이름 혹은 아이디>
2. 도커로 데비안 버스터 이미지 생성

docker pull debian:buster 
확인하려면 docker images



3. 도커로 데비안 버스터 환경 실행 및 접속

docker run -it --name con_debian -p 80:80 -p 443:443 debian:buster
-i옵션은 interactive(입출력), -t 옵션은 tty(터미널) 활성화
일반적으로 터미널 사용하는 것처럼 컨테이너 환경을 만들어주는 옵션
--name [컨테이너 이름] 옵션을 통해 컨테이너 이름을 지정할 수 있다. 안하면 랜덤으로 생성?
-p 호스트포트번호:컨테이너포트번호 옵션은 컨테이너의 포트를 개방한 뒤 호스트 포트와 연결한다.
컨테이너 포트와 호스트 포트에 대한 개념이 궁금하다면 여기 참고.
buster를 명시하지 않아도 자동으로 최신 버전을 불러온다.
터미널 창이 아래처럼 바뀌면 데비안 bash에 접속한 것이다.



종료하고 싶다면 exit. 종료한다고 컨테이너가 중지되는 것은 아니다. 컨테이너는 실행 중인 상태에서 접속만 끊은 것이라고 생각하면 된다. 다시 접속하고 싶다면 attach 명령어 사용.

4. 데비안 버스터에 Nginx, cURL 설치

apt-get -y install nginx curl
데비안에서는 패키지 매니저로 apt-get을 사용한다.
뭔가 설치가 잘 안되면 apt-get update, apt-get upgrade 순서대로 진행하고 다시 설치.
cURL은 서버와 통신할 수 있는 커맨드 명령어 툴이다. url을 가지고 할 수 있는 것들은 다할 수 있다. 예를 들면, http 프로토콜을 이용해 웹 페이지의 소스를 가져온다거나 파일을 다운받을 수 있다. ftp 프로토콜을 이용해서는 파일을 받을 수 있을 뿐 아니라 올릴 수도 있다.
자세한 curl 사용법과 옵션은 여기 참고.
5. Nginx 서버 구동 및 확인

nginx 서버 실행

service nginx start
nginx 상태 확인

service nginx status
[ ok ] nginx is running. 가 뜨면 서버가 잘 돌아가고 있다는 뜻이다.

localhost:80 에 접속해보면 서버와의 성공적인 첫 소통을 확인할 수 있다.



같은 내용을 터미널을 통해서도 확인할 수 있다. 아까 다운받은 curl 을 사용한 방식이다.

curl localhost


nginx 중지

service nginx stop 
6. self-signed SSL 인증서 생성

HTTPS(Hypertext Transfer Protocol over Secure Socket Layer)는 SSL위에서 돌아가는 HTTP의 평문 전송 대신에 암호화된 통신을 하는 프로토콜이다.

이런 HTTPS를 통신을 서버에서 구현하기 위해서는 신뢰할 수 있는 상위 기업이 발급한 인증서가 필요로 한데 이런 발급 기관을 CA(Certificate authority)라고 한다. CA의 인증서를 발급받는것은 당연 무료가 아니다.

self-signed SSL 인증서는 자체적으로 발급받은 인증서이며, 로그인 및 기타 개인 계정 인증 정보를 암호화한다. 당연히 브라우저는 신뢰할 수 없다고 판단해 접속시 보안 경고가 발생한다.

self-signed SSL 인증서를 만드는 방법은 몇 가지가 있는데, 무료 오픈소스인 openssl 을 이용해 쉽게 만들수 있다.

HTTPS를 위해 필요한 개인키(.key), 서면요청파일(.csr), 인증서파일(.crt)을 openssl이 발급해준다.
6.1. openssl 설치

apt-get -y install openssl
6.2. 개인키 및 인증서 생성

openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=Lee/CN=localhost" -keyout localhost.dev.key -out localhost.dev.crt
localhost.dev.key 와 localhost.dev.crt가 생성된다. 옵션들을 하나하나 확인해보면,

req : 인증서 요청 및 인증서 생성 유틸.
-newkey : 개인키를 생성하기 위한 옵션.
-keyout <키 파일 이름> : 키 파일 이름을 지정해 키 파일 생성.
-out <인증서 이름> : 인증서 이름을 지정해 인증서 생성.
days 365 : 인증서의 유효기간을 작성하는 옵션.
6.3. 권한제한

mv localhost.dev.crt etc/ssl/certs/
mv localhost.dev.key etc/ssl/private/
chmod 600 etc/ssl/certs/localhost.dev.crt etc/ssl/private/localhost.dev.key
7. nginx에 SSL 설정 및 url redirection 추가

etc/nginx/sites-available/default 파일을 수정해줄건데, 좀 더 편한 접근을 위해 vim을 설치해준다.

apt-get -y install vim
vim etc/nginx/sites-available/default
default 파일에 https 연결을 위한 설정을 작성한다.

원래는 서버 블록이 하나이며 80번 포트만 수신대기 상태인데, https 연결을 위해 443 포트를 수신대기하고 있는 서버 블록을 추가로 작성해야 한다.

server {
	listen 80;
	listen [::]:80;

	return 301 https://$host$request_uri;
}

server {
	listen 443 ssl;
	listen [::]:442 ssl;

	# ssl 설정
	ssl on;
	ssl_certificate /etc/ssl/certs/localhost.dev.crt;
	ssl_certificate_key /etc/ssl/private/localhost.dev.key;

	# 서버의 root디렉토리 설정
	root /var/www/html;

	# 읽을 파일 목록
	index index.html index.htm index.nginx-debian.html;

	server_name ft_server;
	location / {
		try_files $uri $uri/ =404;
	}
}
80번 포트로 수신되면 443 포트로 리다이렉션 시켜준다.
443 포트를 위한 서버 블록에는 ssl on 과 인증서의 경로를 작성해준다. 나머지는 기존에 있던 설정 그대로.
바뀐 설정을 nginx에 적용한다

service nginx reload
브라우저에서 https://localhost 로 접속했을 때 경고문구가 뜨면 성공.



mac의 chrome에서는 ‘고급’ 설정을 통해서 안전하지 않은 사이트임을 인지하고 접속하는 버튼이 없다.

임시 조치 (꼭 신뢰하는 사이트에서만 사용할 것)

NET::ERR_CERT_REVOKED 화면의 빈 공간의 아무 곳에서 마우스 좌클릭.
키보드로 thisisunsafe 문자열 입력. (화면에 보이지 않으니 그냥 입력)
접속하고자 하는 화면이 보이면 성공. 보이지 않으면 화면 Refresh 하시고 다시 시도.
8. php-fpm 설치 및 nginx 설정

php란?

대표적인 서버 사이드 스크립트 언어.

CGI(공통 게이트웨이 인터페이스) 란?

nginx는 웹서버이기 때문에 정적 콘텐츠밖에 다루지 못한다. 동적 페이지를 구현하기 위해서는 웹 서버 대신 동적 콘텐츠를 읽은 뒤 html로 변환시켜 웹 서버에게 다시 전달해주는 외부 프로그램(php 모듈)이 필요하다. 이런 연결 과정의 방법 혹은 규약을 정의한 것이 CGI이다.



php-fpm (PHP FastCGI Process Manager) 란?

일반 GCI 보다 빠른 처리가 가능한 FastGCI. 정리하자면,

php-fpm 을 통해 nginx와 php를 연동시켜 우리의 웹 서버가 정적 콘텐츠 뿐만 아니라 동적 콘텐츠를 다룰 수 있도록 만드는 것이다.

apt-get install php-fpm
위 명령으로 php-fpm 7.3 버전을 설치해주고 nginx default 파일에 php 처리를 위한 설정을 추가한다.

vim /etc/nginx/sites-available/default
server {
	listen 80;
	listen [::]:80;

	return 301 https://$host$request_uri;
}

server {
	listen 443 ssl;
	listen [::]:442 ssl;

	# ssl setting
	ssl on;
	ssl_certificate /etc/ssl/certs/localhost.dev.crt;
	ssl_certificate_key /etc/ssl/private/localhost.dev.key;

	# Set root dir of server
	root /var/www/html;

	# Auto index
	index index.html index.htm index.nginx-debian.html index.php;

	server_name ft_server;
	location / {
		try_files $uri $uri/ =404;
	}

	# PHP 추가
	location ~ \.php$ {
		include snippets/fastcgi-php.conf;
		fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
	}
}
원래 친절히 기본 default 파일에 php 설정이 주석처리 되어있다. 주석 해제만 하면되는걸 나는 모르고 다 지워버려서 새로 작성했다.
autoindex 리스트에 index.php도 추가해주자.
9. nginx autoindex 설정

autoindex 가 뭔지 알고싶다면 먼저 웹서버가 리소스 매핑과 접근을 어떻게 하는지 부터 알아야한다.

웹 서버는 어떻게 수 많은 리소스 중 요청에 알맞은 콘텐츠를 제공할까?

일반적으로 웹 서버 파일 시스템의 특별한 한 폴더를 웹 콘텐츠를 위해 사용한다. 이 폴더를 문서루트 혹은 docroot라고 부른다. 리소스 매핑의 가장 단순한 형태는 요청 URI를 dotroot 안에 있는 파일의 이름으로 사용하는 것이다.

만약 파일이 아닌 디렉토리를 가리키는 url에 대한 요청을 받았을 때는, 요청한 url에 대응되는 디렉토리 안에서 index.html 혹은 index.htm으로 이름 붙은 파일을 찾아 그 파일의 콘텐츠를 반환한다. 이를 autoindex 라고 부른다.
그래서 우리는 autoindex 기능을 켜줘야한다. nginx default 파일에서 location / 부분에 autoindex on 을 추가한다.

# etc/nginx/sites-available/default
# Autoindex
	index index.html index.htm index.php #index.ngiinx-debian.html;

	server_name ft_server;
	location / {
  	# autoindex on 추가
		autoindex on;
		try_files $uri $uri/ =404;
	}
만약 autoindex가 꺼져 있거나 해당 디렉토리에 index 목록에 해당하는 파일이 없다면, 웹 서버는 자동으로 그 디렉토리의 파일들을 크기, 변경일, 해당 파일에 대한 링크와 함께 열거한 HTML 파일을 반환한다.

루트 디렉터리인 /var/www/html 에 존재하는 index.ngiinx-debian.html 을 주석처리해보면, 읽을 파일이 없다고 생각하고 아래처럼 전체 파일 목록을 반환하는 것을 확인할 수 있다.



10. MariaDB(mysql) 설치

apt-get -y install mariadb-server php-mysql php-mbstring
ft_server 과제에서는 mysql을 설치하라고하지만, 데비안 버스터에서는 mariaDB만을 지원한다. mariaDB도 mysql을 기반으로 만들어졌기때문에 mysql 명령어와 완전히 호환된다.
php-mysql은 php에서 mysql에 접근할 수 있게 해주는 모듈이다.
php-mbstring은 2바이트 확장 문자를 읽을 수 있도록 해주는 모듈이다.
혹시 중간에 에러가 나서 MariaDB를 완전 삭제하고 다시 설치하고 싶다면 여기 참고. 쥬륵..

11. Wordpress 설치

11.1. 설치 및 압축해제

wget https://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz
mv wordpress/ var/www/html/
11.2. 유저 그룹 권한설정

chown -R www-data:www-data /var/www/html/wordpress
nginx.conf를 보면 user로 www-data가 작성되어있다. wordpress의 유저 그룹을 그에 맞게 설정해준 것이다.
11.3. wp-config.php 파일 수정

wp-config-sample.php 을 복사해 wp-config.php 를 만든다.

cp -rp var/www/html/wordpress/wp-config-sample.php var/www/html/wordpress/wp-config.php 
wp-config.php 파일의 DB_NAME, DB_USER, DB_PASSWORD 3가지 항목을 수정해준다.

vim var/www/html/wordpress/wp-config.php 


11.4. wordpress를 위한 DB 테이블 생성

db 설정을 위해 mysql을 실행시킨다.

service mysql start
mysql 접속 및 DB 생성

mysql # 실행시키면 mysql로 들어가짐

CREATE DATABASE wordpress;
# `;` 꼭 입력하기;
SHOW DATABASES; 명령어를 통해 DB목록을 확인할 수 있다.

그 외 mysql 문법이 궁금하다면 예제로 익히는 SQL 문법 확인!

유저 생성

# on mysql
CREATE USER 'daelee'@'localhost' IDENTIFIED BY 'daelee';
GRANT ALL PRIVILEGES ON wordpress.* TO 'daelee'@'localhost' WITH GRANT OPTION;
@'localhost' 는 로컬 접속만 허용하겠다는 뜻이고 @'%'로 작성하면 외부 접속을 허용하겠다는 뜻이다.

설정 업데이트

# on mysql
USE wordpress;
SHOW TABLES;
exit 로 mysql을 빠져나올 수 있다.

php7.3-fpm 재시작

service php7.3-fpm restart
php-mysql로 php 설정이 변경되었기 때문.

11.5. wordpress 로컬로 접속해보기

이제 wordpress DB 설정이 모두 끝났다.

https://127.0.0.1/wordpress/ 로 접속했을때 아래와 같은 페이지가 나오면 성공이다.



계속 을 누르면 몇 가지 설정을 마친 뒤 wordpress를 설치할 수 있다. 대시보드 및 나의 첫 워드프레스 홈페이지를 확인해보자.



12. phpMyAdmin 설치

12.1. 설치 및 압축해제

apt-get install -y wget
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz
tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz
mv phpMyAdmin-5.0.2-all-languages phpmyadmin
mv phpmyadmin /var/www/html/
phpMyAdmin 은 wget으로 설치한다.
압축 해제 후 폴더 이름을 phpmyadmin 으로 바꿔서 우리 서버의 루트 디렉토리(/var/www/html)에 위치시킨다.
12.2. 쿠키 권한을 위한 blowfish 암호 설정

phpmyadmin 폴더에 들어가보면 정말 많은 파일들이 있다. 그 중 config.sample.inc.php을 복사해 config.inc.php 파일을 만든다.

cp -rp var/www/html/phpmyadmin/config.sample.inc.php var/www/html/phpmyadmin/config.inc.php 
blowfish 암호 생성 사이트 에서 키를 생성/복사한 뒤 config.inc.php에 추가한다.

vim var/www/html/phpmyadmin/config.inc.php
$cfg['blowfish_secret'] = ''; /* YOU MUST FILL IN THIS FOR COOKIE AUTH! */
nginx 재시작

service nginx reload
12.3. phpmyadmin을 위한 DB테이블 생성

db 설정을 위해 mysql을 실행시킨다.

service mysql start
phpmyadmin/sql 폴더의 create_table.sql 파일을 mysql로 리다이렉션 시켜준다.

mysql < var/www/html/phpmyadmin/sql/create_tables.sql
12.4. phpmyadmin 로컬로 접속해보기

https://127.0.0.1/phpmyadmin 에 접속한 뒤 wordpress/wp-config.php 에서 설정한 ID와 PW를 입력하면 아래 사진처럼 데이터베이스를 GUI로 편리하게 관리할 수 있다.



이제 지금까지의 과정을 Dockerfile로 만들어 관리해보자.