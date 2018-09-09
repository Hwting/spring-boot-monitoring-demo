# spring-boot-monitoring-demo

## Download Demo application and build

### Download repository

```
$ git clone https://github.com/cloudz-labs/spring-boot-monitoring-demo
$ cd spring-boot-monitoring-demo
```

### Maven build

```
$ mvn clean package
```

### Edit Dockerfile

```
$ vi Dockerfile
FROM openjdk:8-jdk-alpine

ADD target/spring-boot-monitoring-demo-0.0.1-SNAPSHOT.jar app.jar
ADD jmx-exporter/jmx_prometheus_javaagent-0.3.1.jar jmx_prometheus_javaagent-0.3.1.jar
ADD jmx-exporter/tomcat.yaml tomcat.yaml

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-javaagent:/jmx_prometheus_javaagent-0.3.1.jar=8090:/tomcat.yaml","-jar","/app.jar"]
```

- `ADD target/spring-boot-monitoring-demo-0.0.1-SNAPSHOT.jar app.jar`
Add demo application to Docker container

- `jmx-exporter/jmx_prometheus_javaagent-0.3.1.jar`
Add Prometheus JMX exporter agent to docker container

- `jmx-exporter/tomcat.yaml tomcat.yaml`
Add JMX exporter Tomcat configuration file to Docker container

- `ENTRYPOINT ...`
Excution demo and JMX exporter agent

### Docker build

```
$ docker build -t spring-boot-monitoring-demo .

$ docker images
REPOSITORY                                  TAG                 IMAGE ID            CREATED             SIZE
spring-boot-monitoring-demo                 latest              8fc41843a24a        8 seconds ago       118MB
```

### Run demo application

Run application with docker image.

```
$ docker run -p 8080:8080 -p 8090:8090 spring-boot-monitoring-demo
```

Connect to localhost:8080 via web browser. You are able to see "Hello World!" messages.

Connect to localhost:8090 via web browser. You are able to see the following JVM metrics.

```
# HELP process_cpu_seconds_total Total user and system CPU time spent in seconds.
# TYPE process_cpu_seconds_total counter
process_cpu_seconds_total 20.95
# HELP process_start_time_seconds Start time of the process since unix epoch in seconds.
# TYPE process_start_time_seconds gauge
process_start_time_seconds 1.532082779294E9
# HELP process_open_fds Number of open file descriptors.
# TYPE process_open_fds gauge
process_open_fds 37.0
# HELP process_max_fds Maximum number of open file descriptors.
# TYPE process_max_fds gauge
process_max_fds 1048576.0
# HELP process_virtual_memory_bytes Virtual memory size in bytes.
# TYPE process_virtual_memory_bytes gauge
process_virtual_memory_bytes 2.100760576E9
# HELP process_resident_memory_bytes Resident memory size in bytes.
# TYPE process_resident_memory_bytes gauge
process_resident_memory_bytes 2.65465856E8
# HELP jvm_gc_collection_seconds Time spent in a given JVM garbage collector in seconds.
# TYPE jvm_gc_collection_seconds summary
jvm_gc_collection_seconds_count{gc="PS Scavenge",} 15.0
jvm_gc_collection_seconds_sum{gc="PS Scavenge",} 0.18
jvm_gc_collection_seconds_count{gc="PS MarkSweep",} 2.0
jvm_gc_collection_seconds_sum{gc="PS MarkSweep",} 0.262
...
```

### Push docker image to your docker registry

```
$ docker tag spring-boot-monitoring-demo:[VERSION] [REPOSITORY_ADDRESS]/spring-boot-monitoring-demo:[VERSION]

$ docker push [REPOSITORY_ADDRESS]/spring-boot-monitoring-demo:[VERSION]
```

### Deploy demo application to Kubernetes cluster

### Edit Deployment yaml

```
$ vi kubernetes/deployment.yaml
...
spec:
  ...
  template:
    metadata:
      ...
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "8090"
        prometheus.io/path: /metrics
    spec:
      containers:
      - name: spring-boot-monitoring-demo
        image: dtlabs/spring-boot-monitoring-demo:latest
```

- `spec.template.metadata.annotations.prometheus.io/scrape`
Whether discovery or not

- `spec.template.metadata.annotations.prometheus.io/port`
Discovery target port

- `spec.template.metadata.annotations.prometheus.io/path`
Discovery target path

- `spec.template.spec.containers.image`
Docker image path

### Deploy

```
$ kubectl apply -f Kubernetes/deployment.yaml

$ kubectl get po
NAME                                           READY     STATUS    RESTARTS   AGE
spring-boot-monitoring-demo-5795695496-ljfkw   1/1       Running   0          1m
spring-boot-monitoring-demo-5795695496-mqzrr   1/1       Running   0          1m
```
