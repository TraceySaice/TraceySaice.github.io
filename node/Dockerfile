FROM node:20-slim

# 定义一个参数，默认值为en_US.UTF-8
#ARG LANG=en_US.UTF-8
#ENV LANG=${LANG}

# 设置容器时区
RUN apt-get update && apt-get install -y tzdata && rm -rf /var/lib/apt/lists/*

# 设置容器语言环境
RUN apt-get update && apt-get install -y --no-install-recommends locales sudo  && rm -rf /var/lib/apt/lists/*

ARG LANG
ARG TZ=Asia/Shanghai

# 设置时区
ENV TZ=${TZ}

# 安装 locales 包并为指定的语言重新生成 locale
RUN apt-get update && apt-get install -y locales wget  && \
    sed -i "s/^# \(${LANG} .*\)/\1/" /etc/locale.gen && \
    locale-gen || echo "Locale not found" && \
    dpkg-reconfigure -f noninteractive locales

# 如果 LANG 没有被设置，使用默认语言环境
ENV LANG=${LANG:-en_US.UTF-8}
ENV LC_ALL ${LANG}
ENV LANGUAGE=${LANG}