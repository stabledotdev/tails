ARG LANGUAGE_VERSION=1.84.0
FROM rust:${LANGUAGE_VERSION}-bookworm
COPY repo /bot
WORKDIR /bot

ARG BINARY_NAME=bot
ENV BINARY_NAME=${BINARY_NAME}

RUN cargo build --release --target-dir /bot/bin --bin ${BINARY_NAME}
CMD ./bin/release/${BINARY_NAME}
