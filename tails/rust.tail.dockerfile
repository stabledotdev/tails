ARG LANGUAGE_VERSION=1.84.0

FROM ghcr.io/sigstore/cosign/cosign:v2.4.1 AS cosign-bin

FROM rust:${LANGUAGE_VERSION}-bookworm as builder
COPY repo /bot
WORKDIR /bot

ARG BINARY_NAME=bot
ENV BINARY_NAME=${BINARY_NAME}
RUN cargo build --release --bin ${BINARY_NAME}
RUN cp target/release/${BINARY_NAME} /usr/local/bin/bot
RUN rm -rf /bot/target

FROM alpine:latest AS verify
COPY --from=cosign-bin /ko-app/cosign /usr/local/bin/cosign
RUN cosign verify gcr.io/distroless/cc-debian12\
    --certificate-oidc-issuer https://accounts.google.com \
    --certificate-identity keyless@distroless.iam.gserviceaccount.com

FROM gcr.io/distroless/cc-debian12

ARG BINARY_NAME=bot
ENV BINARY_NAME=${BINARY_NAME}

WORKDIR /bot

COPY --from=builder /bot /bot
COPY --from=builder /usr/local/bin/bot /usr/local/bin/bot
CMD ["/usr/local/bin/bot"]