#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo "options ib_core netns_mode=0" > /etc/modprobe.d/ib_core.conf

docker run --net=host -v /usr/bin:/tmp rdma/container_tools_installer

echo "docker_rdma_sriov rdmanetns set --mode=exclusive" >> /etc/rc.d/rc.local
