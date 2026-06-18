# TIS Console Dockerfile
# Uses local tis-uber directory directly
# Supports linux/amd64 (x86) and linux/arm64 (ARM)

FROM eclipse-temurin:11-jre-jammy

LABEL maintainer="datavane"
LABEL description="TIS - Enterprise Data Integration Service Platform"

ENV TZ=Asia/Shanghai
ENV JAVA_JVM_OPTS="-Xms512m -Xmx1G -XX:MetaspaceSize=100m -XX:MaxMetaspaceSize=300m"

# Set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /opt/app/tis-uber

# Copy local tis-uber directory directly
COPY tis-uber /opt/app/tis-uber

# Fix execute permissions (Windows host doesn't preserve them)
# Create data and logs directories
RUN chmod +x bin/tis bin/zookeeper && \
    mkdir -p /opt/data /opt/logs/tis/gc

EXPOSE 8080 56432

ENTRYPOINT ["/opt/app/tis-uber/bin/tis"]
