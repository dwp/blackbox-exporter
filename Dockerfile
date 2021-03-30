FROM alpine:3.12

ARG BLACKBOX_VERSION=0.18.0

# Dependencies
RUN apk add --update --no-cache \
    curl \
    aws-cli

COPY entrypoint.sh /bin/entrypoint.sh

# Download prometheus
RUN curl -k -LSs --output /tmp/blackbox-exporter.tz.gz \
    https://github.com/prometheus/blackbox_exporter/releases/download/v${BLACKBOX_VERSION}/blackbox_exporter-${BLACKBOX_VERSION}.linux-amd64.tar.gz && \
    tar -C /tmp --strip-components=1 -zoxf /tmp/blackbox-exporter.tz.gz && \
    rm -f /tmp/blackbox-exporter.tz.gz && \
    mv /tmp/blackbox_exporter /bin/ && \
    mkdir /blackbox-exporter && \
    chmod 0755 /bin/entrypoint.sh && \
    chown -R nobody:nogroup /blackbox-exporter

# Expose blackbox port
EXPOSE 9115

# Data volume
VOLUME [ "/blackbox-exporter" ]

# Working from data dir
WORKDIR /blackbox-exporter

ENTRYPOINT [ "/bin/entrypoint.sh" ]
