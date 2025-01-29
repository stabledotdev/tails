ARG DENO_VERSION=2.1.6 
FROM denoland/deno:alpine-${DENO_VERSION}
COPY repo /bot
WORKDIR /bot

ARG MAIN_FILE=index.ts
ENV MAIN_FILE=${MAIN_FILE}

RUN deno install
CMD deno ${MAIN_FILE}