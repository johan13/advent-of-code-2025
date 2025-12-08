FROM alpine:3.23
RUN apk add --no-cache bash openjdk25 && \
    wget -P /tmp https://github.com/JetBrains/kotlin/releases/download/v2.2.21/kotlin-compiler-2.2.21.zip && \
    unzip -d /opt /tmp/kotlin-compiler-2.2.21.zip && \
    rm /tmp/kotlin-compiler-2.2.21.zip
ENV PATH="/opt/kotlinc/bin:$PATH"
