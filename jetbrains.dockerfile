FROM jetbrains/youtrack:2023.3.22268
    
LABEL org.opencontainers.image.authors="jason.everling@gmail.com"
    
#Changes need root, switch back to jetbrains in entrypoint
USER root

COPY --chown=root:root --chmod=0755 ./src/run.sh ./usr/local/bin/run.sh

RUN chown -R root:root /usr/local/bin && chmod -R 0755 /usr/local/bin
    
EXPOSE 80 443 8080 8443
    
ENTRYPOINT ["/usr/local/bin/run.sh"]
