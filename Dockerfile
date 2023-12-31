FROM adoptopenjdk/openjdk8:alpine-slim
#FROM openjdk:8-jdk-alpine
USER 1001
EXPOSE 8080
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
#ADD ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]