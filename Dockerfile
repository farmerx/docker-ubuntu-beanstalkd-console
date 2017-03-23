FROM ubuntu:latest

MAINTAINER farmerx "farmerx@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
RUN echo "nameserver 8.8.8.8" >> /etc/resolv.conf 
RUN apt-get update
RUN apt-get install -y build-essential --fix-missing

RUN apt-get install -y vim wget curl openssh-server
RUN mkdir /var/run/sshd

# 将sshd的UsePAM参数设置成no
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

RUN echo "root:123456" | chpasswd

RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 22

# 安装python 扩展 
#RUN apt-get install -y software-properties-common 

RUN wget https://github.com/Luxurioust/aurora/releases/download/2.0/aurora_linux_amd64_v2.0.tar.gz
RUN tar -zxf aurora_linux_amd64_v2.0.tar.gz
RUN mkdir -p /usr/local/aurora
RUN mv aurora /usr/local/aurora
RUN chmod 0777 /usr/local/aurora/aurora
RUN rm -rf aurora_linux_amd64_v2.0.tar.gz
RUN rm -rf aurora
#RUN touch /usr/local/aurora/aurora.conf
COPY aurora.toml /usr/local/aurora/aurora.toml
EXPOSE 3000

# 添加beanstalkd
RUN wget https://github.com/kr/beanstalkd/archive/v1.10.tar.gz
RUN tar -zxf v1.10.tar.gz

WORKDIR beanstalkd-1.10 
RUN make 
RUN mkdir -p /usr/local/beanstalkd/
RUN mv beanstalkd /usr/local/beanstalkd/
RUN rm -rf /tmp/v1.10.tar.gz
RUN rm -rf /tmp/beanstalkd-1.10
RUN mkdir -p /var/beanstalk/binlog 
RUN chmod 0777 -R /var/beanstalk/binlog

CMD ["/usr/bin/supervisord"]

RUN apt-get install -y net-tools 
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


EXPOSE 11300


# 启动方式
# docker run --name beanstalk -p 11300:11300 -p 3000:3000 -P -v d:/docker/beanstalk/binlog:/var/beanstalk/binlog -d beanstalk:latest

















