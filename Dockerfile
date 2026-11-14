# ---- Stage 1: Build the JAR (needs full JDK + Maven) ----
FROM eclipse-temurin:25-jdk-alpine AS builder
WORKDIR /app

# Copy Maven wrapper & pom.xml first so Docker caches downloaded dependencies
COPY mvnw pom.xml ./
COPY .mvn .mvn
RUN chmod +x mvnw && ./mvnw dependency:go-offline

# Now copy your source code and package the JAR
COPY src src
RUN ./mvnw clean package -DskipTests

# ---- Stage 2: Lightweight Runtime Image (JRE only, no source code/Maven) ----
FROM eclipse-temurin:25-jre-alpine
WORKDIR /app

# Create and switch to a non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app/target/*.jar app.jar
RUN chown appuser:appgroup app.jar
USER appuser

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]