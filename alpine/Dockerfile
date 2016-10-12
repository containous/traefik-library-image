FROM alpine:3.4
RUN apk --update upgrade \
    && apk --no-cache --no-progress add ca-certificates \
    && rm -rf /var/cache/apk/*
COPY traefik /
EXPOSE 80
ENTRYPOINT ["/traefik"]
CMD ["--help"]
