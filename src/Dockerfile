FROM debian:bookworm-slim as flutterBuilder
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
        curl git unzip xz-utils zip libglu1-mesa python3 ca-certificates
RUN mkdir /flutter
RUN curl https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.29.3-stable.tar.xz -o /flutter/flutter_linux_3.29.3-stable.tar.xz
RUN tar -xf /flutter/flutter_linux_3.29.3-stable.tar.xz -C /flutter/
ENV PATH "$PATH:/flutter/flutter/bin"
RUN git config --global --add safe.directory /flutter/flutter
COPY fcpxml_web/lib /app/lib
COPY fcpxml_web/web /app/web
COPY fcpxml_web/pubspec.lock /app
COPY fcpxml_web/pubspec.yaml /app
WORKDIR /app
RUN flutter pub get
RUN flutter build web

FROM golang:1.24 as goBuilder
WORKDIR /app
COPY api/go.mod api/go.sum /app/api/
COPY parser/go.mod parser/go.sum /app/parser/
WORKDIR /app/api
RUN go mod download
COPY api/*.go /app/api
COPY parser/*.go /app/parser
RUN go mod tidy
RUN go build .

FROM golang:1.24-alpine
RUN apk add libc6-compat
COPY --from=flutterBuilder /app/build/web /app/api/build/web
COPY --from=goBuilder /app/api/api /app/api
ENV ASSETS="/app/api/build/web"
ENV PORT="8080"
CMD ["/app/api/api"]
