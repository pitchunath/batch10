FROM openjdk:11
EXPOSE 8888
COPY target/bootcamp*.jar.
CMD java -jar ./bootcamp*.jar

