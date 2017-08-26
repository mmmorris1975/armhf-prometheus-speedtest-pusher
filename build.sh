#!/bin/bash -x

ver=${VERSION:="0.0.1"}
NAME=$(basename $(dirname $PWD/Dockerfile))

docker build -t ${NAME}:${ver} -t ${NAME}:latest -t ${NAME}:$(date +%Y%m%d) .
