#!/usr/bin/env bash

HOST_1="admin@thinkcentre-1"
HOST_2="admin@thinkcentre-2"

MACHINES_HOST_1=("192.168.1.211" "192.168.1.212")
MACHINES_HOST_2=("192.168.1.221" "192.168.1.222")

# Stop k3s in HOST_1

for MACHINE in "${MACHINES_HOST_1[@]}"; do
    echo "Stopping k3s on $MACHINE"
    ssh "$HOST_1" "ssh-keygen -R $MACHINE"
    ssh -J "$HOST_1" "root@$MACHINE" "systemctl start k3s"
    done

# Stop k3s in HOST_2

for MACHINE in "${MACHINES_HOST_2[@]}"; do
    echo "Stopping k3s on $MACHINE"
    ssh "$HOST_2" "ssh-keygen -R $MACHINE"
    ssh "$HOST_2" "ssh root@$MACHINE  systemctl start k3s"
done
