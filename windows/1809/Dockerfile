
FROM mcr.microsoft.com/windows/servercore:1809 as core
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Invoke-WebRequest \
        -Uri "https://github.com/containous/traefik/releases/download/v2.0.0-rc4/traefik_v2.0.0-rc4_windows_amd64.zip" \
        -OutFile "/traefik.zip"; \
    Expand-Archive -Path "/traefik.zip" -DestinationPath "/" -Force

EXPOSE 80
ENTRYPOINT ["/traefik"]

# Metadata
LABEL org.opencontainers.image.vendor="Containous" \
    org.opencontainers.image.url="https://traefik.io" \
    org.opencontainers.image.title="Traefik" \
    org.opencontainers.image.description="A modern reverse-proxy" \
    org.opencontainers.image.version="v2.0.0-rc4" \
    org.opencontainers.image.documentation="https://docs.traefik.io"
