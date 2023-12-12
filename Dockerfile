FROM jetbrains/youtrack:2023.3.21798
    
LABEL org.opencontainers.image.authors="jason.everling@gmail.com"
    
COPY --chmod=a+x ./src/ ./
    
EXPOSE 80 443 8080 8443
    
#Changes need root, switch back to jetbrains in entrypoint
USER root

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
