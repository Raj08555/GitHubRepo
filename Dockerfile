FROM debian:jessie

MAINTAINER rajashekhar.vootla@healthfidelity.com

USER root

ARG DEBIAN_FRONTEND=noninteractive

#installing jdk8
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" && \
    apt-get update && \
    echo 'oracle-java8-installer shared/accepted-oracle-license-v1-1 select' true |  /usr/bin/debconf-set-selections && \
    apt-get install -y  oracle-java8-installer

#installing elasticserch 5.5.2
RUN apt-get update && \
    apt-get install -y wget && \
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - && \
    apt-get install apt-transport-https -y && \
    echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-5.x.list && \
    apt-get update && \
    apt-get install elasticsearch -y

COPY run.sh /
RUN chmod +x /run.sh
COPY elasticsearch.init /etc/init.d/elasticsearch
RUN chmod +x /etc/init.d/elasticsearch
COPY elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
#CMD sleep 10000
CMD ["/run.sh"]

