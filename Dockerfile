FROM openjdk:8-jdk-alpine

ADD target/spring-boot-monitoring-demo-0.0.1-SNAPSHOT.jar app.jar
ADD jmx-exporter/jmx_prometheus_javaagent-0.3.1.jar jmx_prometheus_javaagent-0.3.1.jar
ADD jmx-exporter/tomcat.yaml tomcat.yaml

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-javaagent:/jmx_prometheus_javaagent-0.3.1.jar=8090:/tomcat.yaml","-jar","/app.jar"]
