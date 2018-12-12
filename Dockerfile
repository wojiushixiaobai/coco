FROM centos:7.5.1804
LABEL maintainer "wojiushixiaobai"
WORKDIR /opt

RUN set -ex \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && localedef -c -f UTF-8 -i zh_CN zh_CN.UTF-8 \
    && export LC_ALL=zh_CN.UTF-8 \
    && echo 'LANG="zh_CN.UTF-8"' > /etc/locale.conf \
    && yum -y install epel-release gcc git \
    && yum -y install python36 python36-devel \
    && git clone https://github.com/jumpserver/coco.git \
    && yum -y install $(cat /opt/coco/requirements/rpm_requirements.txt) \
    && python3.6 -m venv /opt/py3 \
    && source /opt/py3/bin/activate \
    && pip install --upgrade pip setuptools \
    && pip install -r /opt/coco/requirements/requirements.txt \
    && yum clean all \
    && rm -rf /var/cache/yum/* \
    && rm -rf ~/.cache/pip \
    && mkdir -p /opt/coco/keys \
    && mkdir -p /opt/coco/logs

COPY conf.py /opt/coco/conf.py
COPY readme.txt /opt/readme.txt
COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh

VOLUME /opt/coco/keys

ENV NAME=coco \
    CORE_HOST=http://127.0.0.1:8080
    BOOTSTRAP_TOKEN=nwv4RdXpM82LtSvmV

EXPOSE 2222 5000
ENTRYPOINT ["entrypoint.sh"]
