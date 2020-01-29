FROM ubuntu:18.04

LABEL maintainer="Carlos Rodriguez <carlosrg1997@hotmail.com>"

RUN apt update; apt install -y nginx-full openssh-server sshpass
#RUN apk update && apk add nginx-full openssh-server sshpass && rm -rf /var/cache/apk/*

RUN NGINXCONFFILE=/etc/nginx/nginx.conf && echo "daemon off;" | cat - $NGINXCONFFILE > $NGINXCONFFILE.tmp && mv $NGINXCONFFILE.tmp $NGINXCONFFILE

ADD content/default /etc/nginx/sites-enabled/

ADD content/index.html /sites/

ADD content/run_servers.sh /

RUN mkdir /var/run/sshd

RUN echo "root:root"|chpasswd

RUN sed -i 's|session.*required.*pam_loginuid.so|session optional pam_loginuid.so|' /etc/pam.d/sshd

USER root

EXPOSE 80 22

CMD ["sh", "/run_servers.sh"]
