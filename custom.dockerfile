# Ocie Version, e.g 22.04 unquoted
ARG OCIE_VERSION
    
# YourTrack Version
ARG ITSM_VERSION

# Optional: Change Timezone
ARG TZ=America/North_Dakota/Center
    
FROM bshp/ocie:${OCIE_VERSION}
    
LABEL org.opencontainers.image.authors="jason.everling@gmail.com"
    
ARG ITSM_VERSION
ARG TZ=America/North_Dakota/Center
ARG CDN=https://download-cdn.jetbrains.com/charisma
ARG YOUTRACK_VERSION=${ITSM_VERSION}
    
ENV CDN=${CDN}
ENV HUB_VERSION=https://hub.docker.com/v2/namespaces/jetbrains/repositories/youtrack
ENV YOUTRACK_HOME=/opt/youtrack
ENV PATH=$PATH:$YOUTRACK_HOME/bin
    
RUN <<"EOD" bash
    set -eu;
    # Add packages
    ocie --pkg "-base";
    useradd -m -u 13001 jetbrains;
    wget --quiet --no-cookies ${CDN}/youtrack-${YOUTRACK_VERSION}.zip -O /youtrack-${YOUTRACK_VERSION}.zip;
    wget --quiet --no-cookies ${CDN}/youtrack-${YOUTRACK_VERSION}.zip.sha256 -O /youtrack-${YOUTRACK_VERSION}.zip.sha256;
    YOUTRACK_SIG="$(sha256sum -c /youtrack-${YOUTRACK_VERSION}.zip.sha256 2>&1 | grep OK)";
    if [[ -z "$YOUTRACK_SIG" ]];then
        echo "Signature does not match";
        exit 1;
    fi;
    unzip -qq /youtrack-${YOUTRACK_VERSION}.zip -d /opt;
    mv /opt/youtrack-${YOUTRACK_VERSION} /opt/youtrack;
    rm -f /youtrack-${YOUTRACK_VERSION}.zip youtrack-${YOUTRACK_VERSION}.zip.sha256;
    chown -R jetbrains:jetbrains ${YOUTRACK_HOME} && chmod -R 0775 ${YOUTRACK_HOME};
    ocie --clean "-base";
    echo "System setup complete, YourTrack Version: ${YOUTRACK_VERSION}";
EOD
    
COPY --chown=root:root --chmod=0755 ./src/run.sh ./usr/local/bin/run.sh
    
EXPOSE 80 443 8080 8443
    
VOLUME [/opt/youtrack/backups /opt/youtrack/conf /opt/youtrack/data /opt/youtrack/logs]
    
ENTRYPOINT ["/usr/local/bin/run.sh"]
