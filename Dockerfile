# TIS Console Dockerfile
# Downloads pre-built tis-uber.tar.gz from release server
# Supports linux/amd64 (x86) and linux/arm64 (ARM)

FROM eclipse-temurin:11-jre-jammy

LABEL maintainer="datavane"
LABEL description="TIS - Enterprise Data Integration Service Platform"

ARG TIS_VERSION=5.0.0
ARG TIS_RELEASE_HOST=http://mirror.qlangtech.com

ENV TZ=Asia/Shanghai
ENV JAVA_JVM_OPTS="-Xms512m -Xmx1G -XX:MetaspaceSize=100m -XX:MaxMetaspaceSize=300m"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /opt/app

# Download and extract pre-built tis-uber package
# URL format: http://mirror.qlangtech.com/{version}/tis/tis-uber.tar.gz
RUN apt-get update && apt-get install -y --no-install-recommends curl && \
    curl -fsSL "${TIS_RELEASE_HOST}/${TIS_VERSION}/tis/tis-uber.tar.gz" \
      -o /tmp/tis-uber.tar.gz && \
    tar -xzf /tmp/tis-uber.tar.gz -C /opt/app && \
    rm -f /tmp/tis-uber.tar.gz && \
    apt-get purge -y curl && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/app/tis-uber

RUN mkdir -p /opt/data && \
    addgroup --system tis && \
    adduser --system --ingroup tis tis && \
    chown -R tis:tis /opt/app /opt/data

USER tis

EXPOSE 8080 56432

VOLUME ["/opt/data"]

# Use a wrapper script to keep container running in foreground
# The tis script starts Java in background mode, so we need to keep the container alive
COPY <<'EOF' /opt/app/tis-uber/docker-entrypoint.sh
#!/bin/bash
set -e

# Run the original tis script
/opt/app/tis-uber/bin/tis

# Keep container running by following the log file
tail -f /opt/app/tis-uber/logs/assemble.log 2>/dev/null || tail -f /dev/null
EOF

RUN chmod +x /opt/app/tis-uber/docker-entrypoint.sh

ENTRYPOINT ["/opt/app/tis-uber/docker-entrypoint.sh"]
