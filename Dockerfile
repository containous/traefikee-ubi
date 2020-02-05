FROM registry.access.redhat.com/ubi8/ubi as base

WORKDIR /

ARG version=v2.0.0_linux_amd64

# Download traefikee
RUN curl -sLo "/traefikee_${version}.tar.gz" https://s3.amazonaws.com/traefikee/binaries/v2.0.0/traefikee/traefikee_${version}.tar.gz
RUN tar -zxvf "/traefikee_${version}.tar.gz"

# Download teectl
RUN curl -sLo "/teectl_${version}.tar.gz" https://s3.amazonaws.com/traefikee/binaries/v2.0.0/teectl/teectl_${version}.tar.gz
RUN tar -zxvf "/teectl_${version}.tar.gz"

FROM registry.access.redhat.com/ubi8/ubi-minimal

COPY --from=base /traefikee /
COPY --from=base /teectl /
COPY licenses /licenses

ENV TRAEFIKEE_HOME=/
EXPOSE 80
VOLUME ["/var/run", "/var/lib/traefikee", "/tmp"]
ENTRYPOINT ["/traefikee"]

# Metadata
LABEL vendor="Containous" \
		url="https://containo.us/traefikee" \
		name="TraefikEE" \
		summary="TraefikEE is a production-grade, distributed, and highly available edge routing solution built on top of the open source Traefik." \
		description="TraefikEE is a production-grade, distributed, and highly available edge routing solution built on top of the open source Traefik." \
		version="v2.0.0" \
		documentation="https://docs.containo.us"
