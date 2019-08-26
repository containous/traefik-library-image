
FROM mcr.microsoft.com/windows/servercore:ltsc2019 as core
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Invoke-WebRequest \
        -Uri "https://github.com/containous/traefik/releases/download/v2.0.0-rc1/traefik_v2.0.0-rc1_windows_amd64.zip" \
        -OutFile "/traefik.zip"; \
    Expand-Archive -Path "/traefik.zip" -DestinationPath "/" -Force

FROM mcr.microsoft.com/windows/nanoserver:1809
COPY --from=core /windows/system32/netapi32.dll /windows/system32/netapi32.dll
COPY --from=core /traefik.exe /traefik.exe

EXPOSE 80
ENTRYPOINT ["/traefik"]

# Metadata
LABEL org.opencontainers.image.vendor="Containous" \
    org.opencontainers.image.url="https://traefik.io" \
    org.opencontainers.image.title="Traefik" \
    org.opencontainers.image.description="A modern reverse-proxy" \
    org.opencontainers.image.version="v2.0.0-rc1" \
    org.opencontainers.image.documentation="https://docs.traefik.io"
