FROM alpine:3.10 as core
RUN apk --no-cache add ca-certificates tzdata && update-ca-certificates
RUN set -ex; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		armhf) arch='arm' ;; \
		aarch64) arch='arm64' ;; \
		x86_64) arch='amd64' ;; \
		*) echo >&2 "error: unsupported architecture: $apkArch"; exit 1 ;; \
	esac; \
	wget --quiet -O /usr/local/bin/traefik "https://github.com/containous/traefik/releases/download/v1.7.14/traefik_linux-$arch"; \
	chmod +x /usr/local/bin/traefik

FROM scratch
COPY --from=core /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=core /usr/share/zoneinfo /usr/share/
COPY --from=core /usr/local/bin/traefik /
EXPOSE 80
VOLUME ["/tmp"]
ENTRYPOINT ["/traefik"]

# Metadata
LABEL org.opencontainers.image.vendor="Containous" \
	org.opencontainers.image.url="https://traefik.io" \
	org.opencontainers.image.title="Traefik" \
	org.opencontainers.image.description="A modern reverse-proxy" \
	org.opencontainers.image.version="v1.7.14" \
	org.opencontainers.image.documentation="https://docs.traefik.io"
