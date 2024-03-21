####
# This Dockerfile is used in order to build a container that runs the application in JVM mode
#
# Before building the container image run:
#
# > ./gradlew bootJar
#
# Then, build the image with:
#
# > docker build -t hubsuimz/chatgpt-web-java .
#
# Then run the container using:
#
# > docker run --name chatgpt-web-java -d -p 8080:8080 -v ~/chatgpt-web-java:/app/config -e "JAVA_OPTS=-Xms256m -Xmx256m" hubsuimz/chatgpt-web-java
#
# Next, you need to modify the `app.openai-api-key` or `app.openai-access-token` in the ~/chatgpt-web-java/application-app.properties file, and finally restart the container:
#
# > docker restart chatgpt-web-java
#
# Or:
#
# > docker run --name chatgpt-web-java -d -p 8080:8080 hubsuimz/chatgpt-web-java --app.openai-api-key=sk-xxx
#
# You can configure the behavior using the following environment properties:
# - JAVA_OPTS: JVM options passed to the `java` command (example: -e "JAVA_OPTS=-Xms256m -Xmx256m")
#
# You can configure the docker run command properties: (example: --app.openai-api-key=sk-xxx)
# - app.auth-secret-key: ChatGPT-Web front-end authorization key
#
# - app.openai-api-key: OpenAI API Key, https://platform.openai.com/overview
# - app.openai-api-base-url: openai api url, defualt: https://api.openai.com
# - app.openai-api-mode: gpt-4, gpt-4-0314, gpt-4-32k, gpt-4-32k-0314, gpt-3.5-turbo(default), gpt-3.5-turbo-0301, text-davinci-003, text-davinci-002, code-davinci-002
# - app.openai-sensitive-id: Used to query balance, change this to an `sensitiveId` extracted from the ChatGPT site's `https://platform.openai.com/account/usage`
#
# - app.openai-access-token: Set this to an `accessToken` extracted from the ChatGPT site's `https://chat.openai.com/api/auth/session` response
# - app.openai-reverse-api-proxy-url: Reverse Proxy - Available on accessToken, default: https://bypass.churchless.tech/api/conversation
#
# - app.api-timeout-ms: API request timeout-ms, default: 120000
# - app.max-request-per-hour: Chat API maximum number of requests per hour, 0 - unlimited(default)
#
# - app.socks-proxy.host=
# - app.socks-proxy.port=
# - app.socks-proxy.username=
# - app.socks-proxy.password=
#
# - app.http-proxy.host=
# - app.http-proxy.port=
# FROM : 指定基础镜像， 必须为第一条命令
# maintainer： 维护者信息
# RUN : 在镜像容器中执行命令，有两种执行方式 shell执行和exec执行
# VOLUME：创建一个匿名数据卷挂载点，运行容器时可以从本地主机或其他容器挂在数据卷，一般用来存放数据库和需要保持的数据。
# ADD： 将本地文件添加到容器中，支持tar类型文件自动解压，可以访问网络资源
# EXPOSE： 指定容器对外暴露的端口
# WORKDIR：指定在创建容器后，终端默认登录进来的工作目录
# ENTRYPOINT: 指定容器启动时要运行的命令  ENTRYPOINT [“executable”, “param1”, “param2”] (exec 格式，首选)
# COPY：类似ADD，拷贝文件和目录到镜像中
# Dockerfile的指令按照从上至下顺序执行，每条指令都会创建一个新的镜像层并对镜像进行提交
# ENV  环境变量

####
FROM eclipse-temurin:17-jre-alpine
LABEL maintainer="suimz/chatgpt-web-java<https://github.com/suimz/chatgpt-web-java>"
LABEL version="0.0.1"

VOLUME /tmp
ADD build/libs/app.jar /app/app.jar
WORKDIR /app

ENV JAVA_OPTS="-Xms256m -Xmx256m"

EXPOSE 8080
ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar app.jar --spring.config.additional-location=/app/config/application-app.properties ${0} ${@}"]
