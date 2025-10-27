ARG DENO_VERSION=2.1.6 
FROM denoland/deno:alpine-${DENO_VERSION}
COPY repo /bot
WORKDIR /bot

ARG MAIN_FILE=index.ts
ENV MAIN_FILE=${MAIN_FILE}

ARG STABLE_CA
ENV STABLE_CA=${STABLE_CA}

RUN echo "${STABLE_CA}" > /stable.crt

RUN deno install
CMD deno run --cert /stable.crt ${MAIN_FILE}