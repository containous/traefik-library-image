FROM arm32v6/alpine:3.6
RUN apk --update upgrade \
    && apk --no-cache --no-progress add ca-certificates \
    && rm -rf /var/cache/apk/*
ADD https://github.com/containous/traefik/releases/download/v1.4.0-rc1/traefik_linux-arm /usr/local/bin/
RUN mv /usr/local/bin/traefik_linux-arm /usr/local/bin/traefik \
    && chmod +x /usr/local/bin/traefik
COPY entrypoint.sh /
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
CMD ["--help"]

# Metadata
LABEL org.label-schema.vendor="Containous" \
      org.label-schema.url="https://traefik.io" \
      org.label-schema.name="Traefik" \
      org.label-schema.description="A modern reverse-proxy" \
      org.label-schema.version="v1.4.0-rc1" \
      org.label-schema.docker.schema-version="1.0"
