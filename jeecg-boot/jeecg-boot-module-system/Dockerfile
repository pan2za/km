FROM docker.1ms.run/maven:3.8.7-openjdk-18-slim as build

WORKDIR /app

ADD ./settings.xml /root/.m2/settings.xml

# 使用清华源替换默认源
RUN echo \
    "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free\n" \
    "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free\n" \
    "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free\n" \
    "deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free\n" \
    > /etc/apt/sources.list

# 更新包索引
RUN apt-get update

RUN apt install -y git

RUN git clone https://gitee.com/colornix/km.git 

WORKDIR /app/km/jeecg-boot

RUN mvn clean package -DskipTests

FROM docker.1ms.run/maven:3.8.7-openjdk-18-slim

ENV container docker

# 使用清华源替换默认源
RUN echo \
    "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free\n" \
    "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free\n" \
    "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free\n" \
    "deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free\n" \
    > /etc/apt/sources.list

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
apt install -y libreoffice; \
mkdir /kykms; 

WORKDIR /kykms

COPY --from=build /app/km/jeecg-boot/jeecg-boot-module-system/target/jeecg-boot-module-system-2.4.5.jar ./
ADD ./simsun.ttc /usr/share/fonts



CMD sleep 5;\
java -Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom -jar jeecg-boot-module-system-2.4.5.jar

EXPOSE 8080
