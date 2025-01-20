ARG LANGUAGE_VERSION=22.13.0
FROM node:${LANGUAGE_VERSION}-alpine
COPY repo /bot
WORKDIR /bot

ARG MAIN_FILE=index.js
ENV MAIN_FILE=${MAIN_FILE}

ARG PACKAGE_MANAGER=npm
RUN if [ "$PACKAGE_MANAGER" != "npm" ]; then \
        npm install ${PACKAGE_MANAGER}; \
    fi \
RUN ${PACKAGE_MANAGER} install
CMD node ${MAIN_FILE}