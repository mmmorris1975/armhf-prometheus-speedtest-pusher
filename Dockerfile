FROM arm32v6/alpine:3.6
MAINTAINER Mike Morris

RUN apk update && apk add python2 py2-pip && pip install speedtest-cli prometheus_client
COPY collect_speedtest_metrics.py /collect_speedtest_metrics

ENTRYPOINT [ "/collect_speedtest_metrics" ]
