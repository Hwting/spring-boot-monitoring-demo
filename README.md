# spring-boot-monitoring-demo

## Maven build

```
$ mvn clean package
```

## Docker build

```
$ docker build -t spring-boot-monitoring-demo .

$ docker images
REPOSITORY                                  TAG                 IMAGE ID            CREATED             SIZE
logging-demo                                latest              1444f50dcadc        9 seconds ago       117M
```

## Run demo application

Run application with docker image.

```
$ docker run -p 8080:8080 logging-demo
```

Connect to localhost:8080 via web browser.

You can see "Hello World!" messages.
