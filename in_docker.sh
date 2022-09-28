#!/usr/bin/env bash
# Use nsenter to access docker

if false
then
  "yum install -y util-linux #centos自带yum源有，直接安装即可"
fi

docker_in() {
    NAME_ID=$1
    PID=$(docker inspect -f "{{.State.Pid}}" $NAME_ID)
    nsenter -t $PID -m -u -i -n -p
}

docker_in $1
