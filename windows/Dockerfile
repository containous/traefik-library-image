FROM microsoft/nanoserver:sac2016

COPY ./traefik.exe /traefik.exe

EXPOSE 80
ENTRYPOINT ["/traefik"]

# Metadata
LABEL org.label-schema.vendor="Containous" \
      org.label-schema.url="https://traefik.io" \
      org.label-schema.name="Traefik" \
      org.label-schema.description="A modern reverse-proxy" \
      org.label-schema.version="v2.0.0-alpha1" \
      org.label-schema.docker.schema-version="1.0"
