ARG BUN_VERSION=1.1.43 
FROM oven/bun:${BUN_VERSION}
COPY repo /bot
WORKDIR /bot

ARG MAIN_FILE
ENV MAIN_FILE=${MAIN_FILE}

ARG STABLE_CA
ENV STABLE_CA=${STABLE_CA}

RUN echo "${STABLE_CA}" > /home/bun/stable.crt

RUN bun install
CMD NODE_EXTRA_CA_CERTS=/home/bun/stable.crt bun run ${MAIN_FILE}