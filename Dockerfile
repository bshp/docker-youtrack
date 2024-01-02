FROM ubuntu:jammy
    
LABEL org.opencontainers.image.authors="jason.everling@gmail.com"
    
ARG TZ=America/North_Dakota/Center
ARG CDN=https://download-cdn.jetbrains.com/charisma
ARG YOUTRACK_VERSION=0
    
ENV OS_BASE=22.04
ENV OS_CODENAME=jammy
ENV OS_VERSION=2204
ENV OS_TIMEZONE=${TZ}
ENV CDN=${CDN}
ENV HUB_VERSION=https://hub.docker.com/v2/namespaces/jetbrains/repositories/youtrack
ENV YOUTRACK_HOME=/opt/youtrack
ENV PATH=$PATH:$YOUTRACK_HOME/bin
    
RUN set eux; \
    installPkgs='ca-certificates curl gnupg jq openssl tzdata unzip wget'; \
    ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone; \
    apt-get update; \
    apt-get install -y --no-install-recommends $installPkgs; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    echo "Base packages installed"; \
    TAG_VERSION=${YOUTRACK_VERSION}; \
    if [ ${TAG_VERSION} -eq 0 ];then \
        TAG_VERSION=$(wget --quiet --no-cookies ${HUB_VERSION}/tags?page_size=1 -O - | jq -c '.results[].name' | tr -d \"); \
    fi; \
    echo "TAG_VERSION:${TAG_VERSION}"; \
    echo "YOUTRACK_VERSION=${TAG_VERSION}" >> /etc/environment; \
    useradd -m -u 13001 jetbrains; \
    wget --quiet --no-cookies ${CDN}/youtrack-${TAG_VERSION}.zip -O /youtrack-${TAG_VERSION}.zip; \
    wget --quiet --no-cookies ${CDN}/youtrack-${TAG_VERSION}.zip.sha256 -O /youtrack-${TAG_VERSION}.zip.sha256; \
    YOUTRACK_SIG="$(sha256sum -c /youtrack-${TAG_VERSION}.zip.sha256 2>&1 | grep OK)"; \
    if [ -z "$YOUTRACK_SIG" ];then \
        echo "Signature does not match"; \
        exit 1; \
    fi; \
    unzip -qq /youtrack-${TAG_VERSION}.zip -d /opt; \
    mv /opt/youtrack-${TAG_VERSION} /opt/youtrack; \
    rm -f /youtrack-${TAG_VERSION}.zip youtrack-${TAG_VERSION}.zip.sha256; \
    chown -R jetbrains:jetbrains ${YOUTRACK_HOME} && chmod -R 0775 ${YOUTRACK_HOME}; \
    rm -rf /var/lib/apt/lists/*;
    
COPY --chown=root:root --chmod=0755 ./src/run.sh ./usr/local/bin/run.sh
    
EXPOSE 80 443 8080 8443
    
VOLUME [/opt/youtrack/backups /opt/youtrack/conf /opt/youtrack/data /opt/youtrack/logs]
    
ENTRYPOINT ["run.sh"]
