FROM centos/systemd
LABEL maintainer=jitka.novotna@ruk.cuni.cz
LABEL version=0.4


RUN yum -y install maven ant postgresql-server tomcat tomcat-webapps tomcat-admin-webapps 
#Debug
RUN yum -y install net-tools 
RUN systemctl enable tomcat

RUN adduser -u 1000 dspace
ENV TOMCAT_USER=dspace

WORKDIR /opt/dspace.build
COPY . /opt/dspace.build 
RUN cp /opt/dspace.build/environment /etc/ && \
    cp -r /opt/dspace.build/Catalina /etc/tomcat && \
    chown dspace:dspace  /etc/tomcat/Catalina/localhost/* && \
    mkdir -m 777 /var/lib/dspace/ 

RUN mvn package -Dmirage2.on=true -Denv=build-docker

WORKDIR /opt/dspace.build/dspace/target/dspace-installer
#RUN ant fresh_install

#EXPOSE 8080
