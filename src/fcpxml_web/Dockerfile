FROM debian:bookworm-slim as builder
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
        curl git unzip xz-utils zip libglu1-mesa python3 ca-certificates
RUN mkdir /flutter
RUN curl https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.29.3-stable.tar.xz -o /flutter/flutter_linux_3.29.3-stable.tar.xz
RUN tar -xf /flutter/flutter_linux_3.29.3-stable.tar.xz -C /flutter/
ENV PATH "$PATH:/flutter/flutter/bin"
RUN git config --global --add safe.directory /flutter/flutter
COPY lib /app/lib
COPY web /app/web
COPY pubspec.lock /app
COPY pubspec.yaml /app
WORKDIR /app
RUN flutter pub get
RUN flutter build web

FROM alpine:3.21
RUN apk update && apk upgrade && apk add python3
COPY --from=builder /app/build/web /app/build/web
CMD ["python", "-m", "http.server", "8080", "-d", "/app/build/web"]
