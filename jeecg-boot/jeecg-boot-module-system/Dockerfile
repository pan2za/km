# 第一阶段：构建阶段
FROM docker.1ms.run/maven:3.8.7-openjdk-18-slim

# 设置时区
ENV TZ=Asia/Shanghai

WORKDIR /app

# 添加 Maven 配置文件
ADD ./settings.xml /root/.m2/settings.xml

ADD ./sources.list /etc/apt/sources.list

# 使用清华源替换默认源

RUN apt-get update && \
    apt-get install -y git && \
    apt-get install -y libreoffice libfreetype6 fontconfig fonts-dejavu 

# 克隆并构建 spring-ai 项目
RUN git clone https://gitee.com/shang_jun_shu/spring-ai.git && \
    cd spring-ai && \
    mvn clean package -DskipTests && \
    mvn install -DskipTests

# 克隆并构建 km3 项目
RUN git clone https://github.com/pan2za/km3.git && \
    cd km3/jeecg-boot && \
    mvn clean package -DskipTests

# 第二阶段：运行阶段


# 创建目录并添加字体文件
RUN mkdir /kykms && \
    mkdir -p /usr/share/fonts

ADD ./simsun.ttc /usr/share/fonts

# 从构建阶段复制构建好的 JAR 文件
CMD cp /app/km3/jeecg-boot/jeecg-module-system/jeecg-system-start/target/jeecg-system-start-3.7.1.jar /kykms/

WORKDIR /kykms

# 暴露端口
EXPOSE 8080

# 启动应用
CMD ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "jeecg-system-start-3.7.1.jar"]
