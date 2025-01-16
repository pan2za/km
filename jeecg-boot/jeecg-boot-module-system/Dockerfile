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

RUN git clone https://gitee.com/shang_jun_shu/spring-ai.git

WORKDIR /app/spring-ai

RUN mvn clean package -DskipTests

RUN mvn install -DskipTests

WORKDIR /app

RUN git clone https://github.com/pan2za/km3.git 

WORKDIR /app/km3/jeecg-boot

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

# 更新包索引
RUN apt-get update

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
apt install -y libreoffice libfreetype6; \
apt install -y fontconfig fonts-dejavu; \
mkdir /kykms; 

WORKDIR /kykms

COPY --from=build /app/km3/jeecg-boot/jeecg-module-system/jeecg-system-start/target/jeecg-system-start-3.7.1.jar ./
ADD ./simsun.ttc /usr/share/fonts



CMD sleep 5;\
java -Djava.security.egd=file:/dev/./urandom -jar jeecg-system-start-3.7.1.jar

EXPOSE 8080
