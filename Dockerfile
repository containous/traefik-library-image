FROM scratch
COPY certs/ca-certificates.crt /etc/ssl/certs/
COPY traefik /
EXPOSE 80
ENTRYPOINT ["/traefik"]
