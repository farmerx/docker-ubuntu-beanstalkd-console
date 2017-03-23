# docker-ubuntu-beanstalkd-console
基于 dockers ubuntu14.04 images 搭建beanstalkd服务和beanstalkd 图形控制台

## images info
 
  本镜像基于ubuntu14.04构建的beanstalk服务，并借助开源程序aurora 提供beanstalk图形界面控制台。
  beanstalk 版本为1.10.1，aurora版本为2.0.aurora 默认端口为3000。可在aurora.toml中修改
 
## docker build
```
docker build -t beanstalkd-console .
```
## docker run
```
docker run --name beanstalk -p 11300:11300 -p 3000:3000 -P -v d:/docker/beanstalk/binlog:/var/beanstalk/binlog -d beanstalkd-console:latest
```



