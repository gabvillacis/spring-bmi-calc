FROM openjdk:11-jre-slim

COPY target/bmi-1.0.jar /app.jar

EXPOSE 8000

ENTRYPOINT [ "java", "-jar", "/app.jar" ]