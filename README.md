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
	
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
<위키백과>
도커(docker)는 리눅스의 응용 프로그램들을 소프트웨어 컨테이너 안에 배치시키는 일을 자동화하는 오픈소스 프로젝트이다. 도커 웹 페이지의 기능을 인용하면 다음과 같다.

도커 컨테이너는 일종의 소프트웨어의 실행에 필요한 모든 것을 포함하는 완전한 파일 시스템 안에 감싼다. 여기에는 코드, 런타임, 시스템 도구, 시스템 라이브러리 등 서버에 설치되는 무엇이든 아우른다. 이는 실행 중인 환경에 관계없이 언제나 동일하게 실행될 것을 보증한다.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


도커란?
도커는 2013년 3월 산타크라라에서 열린 pycon conference에서 dotCloud의 창업자인 Solomon Hykes가 The future of Linux Containers라는 세션을 발표하면서 처음 세상에 알려졌습니다.

도커("docker")란 컨테이너 기반의 오픈소스 가상화 플랫폼이다.

컨테이너라 하면 수출에 쓰이는 배에 실는 네모난 화물 수송용 박스를 연상할 수 있다. 가가의 컨테이너 안에는 옷, 신발, 전자제품, 술, 과일 등 다양한 화물을 넣을 수 있고 규격화되어 컨테이너선이나 트레일러 등 다양한 운송수단으로 쉽게 옮길 수 있습니다.

서버에서 언습되는 컨테이너 또한 배에 실어 운송에 쓰는 컨테이너와 비슷합니다. 다양한 프로그램, 실행환경을 컨테이너로 옮긴다로 추상화하여 동일한 인터페이스를 제공하여 프로그램의 배포 및 관리를 단순하게 해줍니다. 
백엔드 프로그램, 데이터베이스 서버, 메시지 큐 등 어떤 프로그램도 컨테이너로 추상화 할 수 있고 조립PC, AWS, AZURE, GOOGLE CLOUD 등 어디에서는 실행하여 사용할 수 있습니다.

컨테이너를 가장 잘 사용하고 있는 기업은 구글입니다. 
2014년 발표에 따르면 구글은 모든 서비스들이 컨테이너로 동작하고 매주 20억 개의 컨테이너를 구동한다고 합니다. 

<컨테이너(container)>
컨테이너는 격리된 공간에서 프로세스가 동작하는 기술입니다. 가상화 기술의 하나이지만 기존 방식과는 차이가 있습니다.

기존의 가상화 방식은 주로 OS를 가상화 하였습니다.

(가상화 : 물리적인 하드웨어(HW)장치를 논리적인 객체로 추상화하는 것을 의미합니다. 다시말해서 하나의 하드웨어를 여러개 처럼 동작시키거나 반대로 여러 개의 장치를 묶어 하나의 장치인 것처럼 사용자에게 공유자원으로 제공할 수 있게 만드는 것 이렇게 가상화하게 되면, 컴퓨팅 자원은 프로세스(CPU), 메모리(MEMORY), 스토리지(STORAGE), 네트워크(NETWORK)를 포함하여, 이 들을 쪼개거나 합쳐서 자원을 더욱 더 효율적으로 사용할 수 있게 하고, 분산처리를 가능할 수 있게 만드는 것입니다.)

우리에게 익숙한 VMware나 VirtureBox같은 가상머신은 호스트 OS위에 게스트 OS전체를 가상화하여 사용하는 방식입니다. 이 방식은 여러가지 OS를 가상화(윈도우에서 리눅스를 돌리게 하는것 등)를 할 수 있고 비교적 사용법이 간단하지만 무겁고 느려서 운영환경에서 사용할 수 없습니다.

이렇게 느린것을 극복하기 위해서 CPU 가상화 기술(HVM)을 이용한 KVM(kernel-based virtual machine)과 반가상화 방식(paravirtualization)의 XEN이 등장합니다. 이러한 방식은 게스트 OS가 필요하긴 하지만 전체 OS를 가상화하는 방식이 아니었기 떄문에 호스트형 가상화 방식에 비해 서능이 향상되었습니다.
이러한 기술들은 OpwnStack이나 AWS, Rackspace같은 클라우드 서비스에서 가상 컴퓨팅 기술이 기반이 되었습니다.
