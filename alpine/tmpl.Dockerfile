FROM alpine:$ALPINE_VERSION
RUN apk --no-cache add ca-certificates
RUN set -ex; \
	apkArch="$(apk --print-arch)"; \
	case "${DOLLAR}apkArch" in \
		armhf) arch='arm' ;; \
		aarch64) arch='arm64' ;; \
		x86_64) arch='amd64' ;; \
		*) echo >&2 "error: unsupported architecture: ${DOLLAR}apkArch"; exit 1 ;; \
	esac; \
	wget --quiet -O /usr/local/bin/traefik "https://github.com/containous/traefik/releases/download/$VERSION/traefik_linux-${DOLLAR}arch"; \
	chmod +x /usr/local/bin/traefik
COPY entrypoint.sh /
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
CMD ["traefik"]

# Metadata
LABEL org.label-schema.vendor="Containous" \
      org.label-schema.url="https://traefik.io" \
      org.label-schema.name="Traefik" \
      org.label-schema.description="A modern reverse-proxy" \
      org.label-schema.version="$VERSION" \
      org.label-schema.docker.schema-version="1.0"
