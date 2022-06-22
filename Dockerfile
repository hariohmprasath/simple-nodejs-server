# build stage build the jar with all our resources
FROM maven:3.5.2-jdk-8 as build

ARG VERSION
ARG JAR_PATH

VOLUME /tmp
WORKDIR /
COPY . .

RUN mvn clean install -DskipTests
RUN mv target/buildpack-demo-0.0.1-SNAPSHOT.jar /app.jar

# package stage
FROM openjdk:8-jdk-alpine
WORKDIR /
# copy only the built jar and nothing else
COPY --from=build /app.jar /

ENV VERSION=$VERSION
ENV JAVA_OPTS=-Dspring.profiles.active=production

EXPOSE 8080

ENTRYPOINT ["sh","-c","java -jar -Dspring.profiles.active=production /app.jar"]
