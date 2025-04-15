FROM python:3.11-slim as base

FROM base as builder
RUN apt -qq update \
    && apt install -y --no-install-recommends g++ \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip3 install --prefix="/reqs" -r requirements.txt

FROM base
WORKDIR /usr/src/app
VOLUME /usr/src/app/scripts
COPY --from=builder /reqs /usr/local
COPY logo-kira-locust.png /usr/local/lib/python3.11/site-packages/locust/webui/dist/assets
COPY icon-kira.ico /usr/local/lib/python3.11/site-packages/locust/webui/dist/assets
COPY index-BdLZCA0W.js /usr/local/lib/python3.11/site-packages/locust/webui/dist/assets
COPY index.html /usr/local/lib/python3.11/site-packages/locust/webui/dist/
ENTRYPOINT ["locust"]