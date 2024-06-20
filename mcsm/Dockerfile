FROM node:20-slim
ARG INSTALL_PATH=/opt/docker-mcsm
ARG TZ=Asia/Shanghai
ARG LANG=zh_CN.UTF-8
ENV TZ=${TZ}
WORKDIR $INSTALL_PATH
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources
RUN apt-get update && apt-get install -y tzdata wget tar locales sudo && rm -rf /var/lib/apt/lists/*
RUN sed -i "s/^# \(${LANG} .*\)/\1/" /etc/locale.gen && \
    locale-gen || echo "Locale not found" && \
    dpkg-reconfigure -f noninteractive locales
    
ENV LANG=${LANG}
ENV LC_ALL ${LANG}
ENV LANGUAGE=${LANG}

RUN wget https://github.com/MCSManager/MCSManager/releases/latest/download/mcsmanager_linux_release.tar.gz && tar vxf mcsmanager_linux_release.tar.gz && rm -rf web mcsmanager_linux_release.tar.gz *.sh

CMD ["node", "app.js"]