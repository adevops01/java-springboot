# ---- Stage 1: Build the JAR (uses Maven + JDK 25) ----
FROM maven:3.9-eclipse-temurin-25-alpine AS builder
WORKDIR /app

# Copy pom.xml first so Docker caches downloaded dependencies
COPY pom.xml ./
RUN mvn dependency:go-offline

# Copy source code and package the JAR
COPY src src
RUN mvn clean package -DskipTests

# ---- Stage 2: Lightweight Runtime Image (JRE only) ----
FROM eclipse-temurin:25-jre-alpine
WORKDIR /app

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app/target/*.jar app.jar
RUN chown appuser:appgroup app.jar
USER appuser

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]