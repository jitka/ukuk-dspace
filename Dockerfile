FROM centos/systemd
#FROM centos
LABEL maintainer=jitka.novotna@ruk.cuni.cz
LABEL version=0.4

RUN yum -y install maven ant postgresql-server tomcat tomcat-webapps tomcat-admin-webapps
#Debug
RUN yum -y install net-tools git curl unzip
RUN systemctl enable tomcat

RUN adduser -u 1000 dspace
ENV TOMCAT_USER=dspace

WORKDIR /opt/dspace.build
#ADD . /opt/dspace.build 
RUN curl https://codeload.github.com/jitka/ukuk-dspace/zip/feature/docker --output dspace.zip && \
    unzip dspace.zip && \
    mv ukuk-dspace-feature-docker/* .
ADD build-docker.properties Catalina /opt/dspace.build/


RUN cp /opt/dspace.build/environment /etc/ && \
    cp -r /opt/dspace.build/Catalina /etc/tomcat && \
    chown dspace:dspace  /etc/tomcat/Catalina/localhost/* && \
    mkdir -m 777 /var/lib/dspace/ 

WORKDIR /opt/dspace.build
RUN mvn package -Dmirage2.on=true -Denv=build-docker
     

WORKDIR /opt/dspace.build/dspace/target/dspace-installer
