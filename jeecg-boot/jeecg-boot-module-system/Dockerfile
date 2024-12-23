FROM registry.cn-hangzhou.aliyuncs.com/jeecgdocker/alpine-java:8_server-jre_unlimited

ENV container docker

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
yum install libreoffice.x86_64 -y; \
mkdir /kykms; 

WORKDIR /kykms

ADD ./target/jeecg-boot-module-system-2.4.5.jar ./
ADD ./simsun.ttc /usr/share/fonts

CMD sleep 5;\
java -Djava.security.egd=file:/dev/./urandom -jar jeecg-boot-module-system-2.4.5.jar

EXPOSE 8080
