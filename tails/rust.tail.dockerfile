# syntax=docker.io/docker/dockerfile:1.7-labs
# ^ Required to support --exclude in COPY

ARG LANGUAGE_VERSION=1.84.0
FROM rust:${LANGUAGE_VERSION}-bookworm as builder
COPY repo /bot
WORKDIR /bot

ARG BINARY_NAME=bot
ENV BINARY_NAME=${BINARY_NAME}
RUN cargo build --release --bin ${BINARY_NAME}

### Check signature of Google's distroless debian image
FROM ghcr.io/sigstore/cosign/cosign:v2.4.1
RUN cosign verify gcr.io/distroless/cc-debian12 --certificate-oidc-issuer https://accounts.google.com --certificate-identity keyless@distroless.iam.gserviceaccount.com

FROM gcr.io/distroless/cc-debian12 

ARG BINARY_NAME=bot
ENV BINARY_NAME=${BINARY_NAME}

WORKDIR /bot

COPY --from=builder --exclude=target --exclude=.git /bot /bot
COPY --from=builder /bot/target/release/${BINARY_NAME} /usr/local/bin/bot
CMD ["/usr/local/bin/bot"]
