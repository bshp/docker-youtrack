# YourTrack Version
ARG ITSM_VERSION
    
FROM jetbrains/youtrack:${ITSM_VERSION}
    
LABEL org.opencontainers.image.authors="jason.everling@gmail.com"
    
EXPOSE 80 443 8080 8443
    
ENTRYPOINT ["/bin/bash" "/run.sh"]
