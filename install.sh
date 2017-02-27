#!/bin/bash -x

function cp_set_perms() {
  src=$1
  dest=$2
  mode=$3
  owner=$4

  sudo cp $src $dest
  sudo chown $owner $dest
  sudo chmod $mode $dest
}

REPO_DIR=$(dirname $0)

if [ $(ps -q 1 -o comm=) == systemd ]
then
  for f in speedtest-pusher-container.service speedtest-pusher.timer
  do
    cp_set_perms $REPO_DIR/systemd-${f} /etc/systemd/system/$f 0644 root:root
    sudo systemctl enable $f
  done
else
  echo "TODO: add install steps for other init systems (SysV/upstart would be next)"
fi
