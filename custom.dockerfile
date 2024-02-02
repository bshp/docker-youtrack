# Ocie Version, e.g 22.04 unquoted
ARG OCIE_VERSION
    
# YourTrack Version
ARG ITSM_VERSION
    
FROM bshp/ocie:${OCIE_VERSION}
    
ARG ITSM_VERSION
    
ENV APP_TYPE="itsm" \
    CDN="https://download-cdn.jetbrains.com/charisma" \
    PATH=$PATH:/opt/youtrack/bin \
    YOUTRACK_HOME=/opt/youtrack \
    YOUTRACK_VERSION=${ITSM_VERSION} \
    HUB_VERSION="https://hub.docker.com/v2/namespaces/jetbrains/repositories/youtrack"
    
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
    
EXPOSE 80 443 8080 8443
    
VOLUME [/opt/youtrack/backups /opt/youtrack/conf /opt/youtrack/data /opt/youtrack/logs]
    
ENTRYPOINT ["/usr/local/bin/ociectl", "--run"]
