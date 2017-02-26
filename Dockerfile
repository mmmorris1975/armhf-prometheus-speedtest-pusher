FROM hypriot/rpi-python:latest
MAINTAINER Mike Morris

RUN pip install speedtest-cli prometheus_client

ENTRYPOINT [ "/bin/sh" ]
