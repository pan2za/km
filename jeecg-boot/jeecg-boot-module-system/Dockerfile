FROM docker.1ms.run/maven:3-jdk-8 as build

WORKDIR /app

RUN git clone https://gitee.com/colornix/km.git 
ADD ./settings.xml /root/.m2/settings.xml
WORKDIR /app/km/jeecg-boot

RUN mvn clean package -DskipTests


FROM registry.cn-hangzhou.aliyuncs.com/jeecgdocker/alpine-java:8_server-jre_unlimited 

ENV container docker

RUN cat /etc/alpine-release
RUN apk add --no-cache --repository http://mirrors.tuna.tsinghua.edu.cn/alpine/v3.8/main/ alpine-keys
RUN apk add --no-cache alpine-keys
# 替换默认源为国内源
RUN echo "http://mirrors.tuna.tsinghua.edu.cn/alpine/v3.8/main/" > /etc/apk/repositories && \
    echo "http://mirrors.tuna.tsinghua.edu.cn/alpine/v3.8/community/" >> /etc/apk/repositories
RUN apk update
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
apk add libreoffice; \
mkdir /kykms; 

WORKDIR /kykms

COPY --from=build /app/km/jeecg-boot/jeecg-boot-module-system/target/jeecg-boot-module-system-2.4.5.jar ./
ADD ./simsun.ttc /usr/share/fonts

CMD sleep 5;\
java -Djava.security.egd=file:/dev/./urandom -jar jeecg-boot-module-system-2.4.5.jar

EXPOSE 8080
