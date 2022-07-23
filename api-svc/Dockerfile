##############################################################################
# Python FastAPI Simple Microservice Application
##############################################################################
FROM python:3.10.5-slim

ARG user=app
ARG group=app
ARG APP_ROOT=/micro/app

ENV VIRTUAL_ENV=/micro/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

LABEL maintainer="Adriel Perkins" \
    version="1.0.0" \
    description="FastAPI Simple Microservice Application" \
    license="MIT"

USER root

RUN apt-get update \
    && apt-get clean \
    && adduser ${user} \
    && mkdir /micro \
    && chown ${user}:${group} /micro

USER ${user}:${group}

WORKDIR /micro

COPY src/requirements.txt /micro/requirements.txt
COPY src/helm_test.py /micro/helm_test.py

RUN python3 -m venv $VIRTUAL_ENV \
    && . $VIRTUAL_ENV/bin/activate \
    && pip install \
        --no-cache-dir \
        --upgrade pip \
    && pip install \
        --no-cache-dir \
        --upgrade \
        -r /micro/requirements.txt \
    && rm /micro/requirements.txt

COPY ./app /micro/app

ENTRYPOINT ["uvicorn", "app.main:app"]

CMD ["--proxy-headers", "--host", "0.0.0.0", "--port", "8080"]
