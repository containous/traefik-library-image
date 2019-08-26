FROM microsoft/nanoserver:sac2016
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Invoke-WebRequest \
    -Uri "https://github.com/containous/traefik/releases/download/v1.7.14/traefik_windows-amd64.exe" \
    -OutFile "/traefik.exe"

EXPOSE 80
ENTRYPOINT ["/traefik"]

# Metadata
LABEL org.opencontainers.image.vendor="Containous" \
    org.opencontainers.image.url="https://traefik.io" \
    org.opencontainers.image.title="Traefik" \
    org.opencontainers.image.description="A modern reverse-proxy" \
    org.opencontainers.image.version="v1.7.14" \
    org.opencontainers.image.documentation="https://docs.traefik.io"
