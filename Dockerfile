# Builds the frontend, bundles its static files into the backend jar and
# produces a single runtime image. Build context is the repository root.

FROM node:24-bookworm-slim AS frontend

WORKDIR /frontend

RUN corepack enable

COPY frontend/package.json frontend/pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

COPY frontend/ ./

# Vite inlines VITE_* values into the bundle at build time. VITE_PUBLIC_URL must be
# defined (index.html references it) but is empty when the app is served from "/".
ARG VITE_PUBLIC_URL=
ARG VITE_BACK_BASE_URL
ARG VITE_BACK_FILE_BASE_URL
ARG VITE_CLOUD_FRONT_BASE_URL
ARG VITE_CLIENT_ID

RUN pnpm build

FROM eclipse-temurin:17-jdk-jammy AS builder

ARG STATIC_PATH=src/main/resources/static
ARG API_DOCS=api-docs.yaml

WORKDIR /project

COPY backend/ .
COPY --from=frontend /frontend/dist/ ${STATIC_PATH}/

RUN chmod +x gradlew && \
    mkdir -p "$STATIC_PATH" && \
    mv "$API_DOCS" "$STATIC_PATH" && \
    ./gradlew bootJar --no-daemon

FROM eclipse-temurin:17-jre-jammy

WORKDIR /webapp

RUN groupadd -r app && \
    useradd -r -g app -d /webapp -s /bin/false app && \
    mkdir -p image log && \
    chown -R app:app /webapp

COPY --from=builder --chown=app:app /project/build/libs/*.jar app.jar

EXPOSE 8080

USER app

ENTRYPOINT ["java", "-jar", "app.jar"]
