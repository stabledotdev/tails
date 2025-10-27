ARG PYTHON_VERSION=3.14
FROM python:${PYTHON_VERSION}-alpine
COPY repo /bot
WORKDIR /bot

ARG MAIN_FILE=main.py
ENV MAIN_FILE=${MAIN_FILE}

ARG REQUIREMENTS_FILE=requirements.txt
ENV REQUIREMENTS_FILE=${REQUIREMENTS_FILE}

ARG VENV_ENABLED=false
ENV VENV_ENABLED=${VENV_ENABLED}

RUN if [ -f "${REQUIREMENTS_FILE}" ]; then \
        if [ "$VENV_ENABLED" = "true" ]; then \
            python -m venv /opt/venv; \
            . /opt/venv/bin/activate; \
            pip install --no-cache-dir -r "${REQUIREMENTS_FILE}"; \
        else \
            pip install --no-cache-dir -r "${REQUIREMENTS_FILE}"; \
        fi \
    fi

CMD if [ "$VENV_ENABLED" = "true" ]; then \
        . /opt/venv/bin/activate && python ${MAIN_FILE}; \
    else \
        python ${MAIN_FILE}; \
    fi
