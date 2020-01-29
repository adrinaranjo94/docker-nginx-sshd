FROM ubuntu:18.04

LABEL maintainer="Carlos Rodriguez <carlosrg1997@hotmail.com>"

RUN apt update; apt install -y nginx-full openssh-server sshpass nano
#RUN apk update && apk add nginx-full openssh-server sshpass && rm -rf /var/cache/apk/*

RUN NGINXCONFFILE=/etc/nginx/nginx.conf && echo "daemon off;" | cat - $NGINXCONFFILE > $NGINXCONFFILE.tmp && mv $NGINXCONFFILE.tmp $NGINXCONFFILE

ADD content/default /etc/nginx/sites-enabled/

ADD content/index.html /sites/

ADD content/run_servers.sh /

RUN mkdir /var/run/sshd

RUN echo "root:root"|chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

USER root

EXPOSE 80 22

CMD ["sh", "/run_servers.sh"]
