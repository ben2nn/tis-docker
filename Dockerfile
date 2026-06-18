# TIS Console Dockerfile
# Uses local tis-uber directory directly
# Supports linux/amd64 (x86) and linux/arm64 (ARM)

FROM eclipse-temurin:11-jre-jammy

LABEL maintainer="datavane"
LABEL description="TIS - Enterprise Data Integration Service Platform"

ENV TZ=Asia/Shanghai
ENV JAVA_JVM_OPTS="-Xms512m -Xmx1G -XX:MetaspaceSize=100m -XX:MaxMetaspaceSize=300m"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install gosu for user switching (official Docker image pattern)
RUN apt-get update && apt-get install -y gosu && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/app

# Copy local tis-uber directory directly
COPY tis-uber /opt/app/tis-uber

# Fix execute permissions (Windows host doesn't preserve them)
RUN chmod +x /opt/app/tis-uber/bin/tis /opt/app/tis-uber/bin/zookeeper

WORKDIR /opt/app/tis-uber

# Create tis user and set base directory permissions
RUN mkdir -p /opt/data /opt/logs/tis && \
    addgroup --system tis && \
    adduser --system --ingroup tis tis && \
    chown -R tis:tis /opt/app /opt/data /opt/logs

# Copy entrypoint and ensure execute permission
COPY entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

# Do NOT set USER here - entrypoint runs as root to fix permissions
# then drops to tis user via gosu

EXPOSE 8080 56432

ENTRYPOINT ["/opt/entrypoint.sh"]
