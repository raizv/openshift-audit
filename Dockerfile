# Defines the production environment for our application

FROM python:3.7-alpine

ENV HOME=/app \
    API_TOKEN='YOUR_API_TOKEN' \
    API_HOST='https://localhost:8443'

WORKDIR /app

RUN set -ex && \
    chgrp -R 0 /app && \
    chmod -R g=u /app && \
    apk add --update --no-cache g++ make libffi libffi-dev python-dev openssl-dev

COPY requirements.txt src/ /app/

RUN set -ex && \
    pip install -r requirements.txt && \
    apk del g++ make libffi libffi-dev python-dev openssl-dev && \
    sleep 1h

USER 1001
ENTRYPOINT ["python3"]
CMD ["--version"]
