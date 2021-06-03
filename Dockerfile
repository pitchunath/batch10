FROM openjdk:8-jdk-alpine
EXPOSE 8087
COPY target/bootcamp-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
