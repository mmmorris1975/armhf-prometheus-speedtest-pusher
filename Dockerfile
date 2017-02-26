FROM hypriot/rpi-python:latest
MAINTAINER Mike Morris

RUN pip install speedtest-cli prometheus_client
COPY collect_speedtest_metrics.py /collect_speedtest_metrics

ENTRYPOINT [ "/collect_speedtest_metrics" ]
