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
