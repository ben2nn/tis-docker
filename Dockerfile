# TIS Console Dockerfile
# Uses local tis-uber directory directly
# Supports linux/amd64 (x86) and linux/arm64 (ARM)

FROM eclipse-temurin:11-jre-jammy

LABEL maintainer="datavane"
LABEL description="TIS - Enterprise Data Integration Service Platform"

ENV TZ=Asia/Shanghai
ENV JAVA_JVM_OPTS="-Xms512m -Xmx1G -XX:MetaspaceSize=100m -XX:MaxMetaspaceSize=300m"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /opt/app

# Copy local tis-uber directory directly
COPY tis-uber /opt/app/tis-uber

# Fix execute permissions (Windows host doesn't preserve them)
RUN chmod +x /opt/app/tis-uber/bin/tis /opt/app/tis-uber/bin/zookeeper

WORKDIR /opt/app/tis-uber

RUN mkdir -p /opt/data && \
    addgroup --system tis && \
    adduser --system --ingroup tis tis && \
    chown -R tis:tis /opt/app /opt/data

USER tis

EXPOSE 8080 56432

VOLUME ["/opt/data"]

ENTRYPOINT ["/bin/bash", "-c", "/opt/app/tis-uber/bin/tis start && tail -f /opt/app/tis-uber/logs/tis.log"]
