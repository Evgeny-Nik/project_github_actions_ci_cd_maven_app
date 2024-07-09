FROM maven:3.8.6 as maven

COPY . .

RUN mvn package



FROM openjdk:17-jdk-slim as run

ARG APP_VERSION

COPY --from=maven /target/my-app-$APP_VERSION.jar .

ENV APP my-app-$APP_VERSION.jar

CMD java -jar $APP 