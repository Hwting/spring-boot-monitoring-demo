# Apache Tomcat image with build artifact

FROM tomcat:8.5.4-jre8

MAINTAINER SK CPS 

ENV JAVA_OPTS -Djava.security.egd=file:/dev/./urandom
ENV CATALINA_OPTS -Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Djava.rmi.server.hostname=localhost -javaagent:/usr/local/tomcat/conf/jmx_prometheus_javaagent-0.2.0.jar=8090:/usr/local/tomcat/conf/tomcat.yaml

RUN apt-get update -qq \
  && apt-get install -qqy curl wget \
  && apt-get clean \
  && touch /var/log/spring-music.log \
  && chmod 666 /var/log/spring-music.log \
  && mv /usr/local/tomcat/webapps/ROOT /usr/local/tomcat/webapps/_ROOT

COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
COPY tomcat.yaml /usr/local/tomcat/conf/tomcat.yaml
COPY jmx_prometheus_javaagent-0.2.0.jar /usr/local/tomcat/conf/jmx_prometheus_javaagent-0.2.0.jar
COPY spring-music.war /usr/local/tomcat/webapps/ROOT.war

ADD ./start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh
CMD [ "/usr/local/bin/start.sh" ]
