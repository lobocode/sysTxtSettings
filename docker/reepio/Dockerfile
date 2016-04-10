#Versão unica p2plemaf

FROM centos:7
MAINTAINER Vitor Lobo Ramos <vitor.lobo@lemaf.ufla.br>

LABEL Description="p2p Lemaf com reep.io" Vendor="Lemaf" Version="1.0"
RUN mkdir -p /home/reepio/

# Install nodejs / npm
RUN curl -sL https://rpm.nodesource.com/setup_4.x | bash -

# Install rsync, nodejs, supervisor
RUN yum -y install nodejs rsync python-setuptools
RUN easy_install supervisor 


# Transfer files
COPY reepio-peering-server /home/reepio/reepio-peering-server/ 
COPY reepio /home/reepio/reepio/

# Supervisord.conf
COPY supervisord.conf /etc/supervisord.conf

# Ports
EXPOSE 9001
EXPOSE 8080

# Default directory
WORKDIR /home/reepio

# Run supervisord
#CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
ENTRYPOINT ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
