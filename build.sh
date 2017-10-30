#!/bin/bash -x

ver=${VERSION:="0.0.2"}
NAME=$(basename $(dirname $PWD/Dockerfile))

declare -a TAGS
TAGS=($ver $(date +%Y%m%d))

NAME=$(basename $(dirname $PWD/Dockerfile))

if [ $REPO_HOST ]
then
  NAME=${REPO_HOST}/${NAME}
fi

docker build -t ${NAME}:latest $@ .

if [ $REPO_HOST ]
then
  docker push ${NAME}:latest
fi

for i in ${TAGS[@]}
do
  docker tag ${NAME}:latest ${NAME}:$i

  if [ $REPO_HOST ]
  then
    docker push ${NAME}:$i
  fi
done
