FROM tomcat:8.5.4-jre8

ENV JAVA_OPTS -Djava.security.egd=file:/dev/./urandom
ENV CATALINA_OPTS -Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Djava.rmi.server.hostname=localhost -javaagent:/usr/local/tomcat/conf/jmx_prometheus_javaagent-0.3.1.jar=8080:/usr/local/tomcat/conf/tomcat.yaml -jar /usr/local/tomcat/conf/app.jar

COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
COPY tomcat.yaml /usr/local/tomcat/conf/tomcat.yaml

ADD target/spring-boot-monitoring-demo-0.0.1-SNAPSHOT.jar /usr/local/tomcat/conf/app.jar
ADD jmx_prometheus_javaagent-0.3.1.jar /usr/local/tomcat/conf/jmx_prometheus_javaagent-0.3.1.jar
ADD start.sh /usr/local/bin/start.sh

RUN chmod +x /usr/local/bin/start.sh
CMD [ "/usr/local/bin/start.sh" ]
