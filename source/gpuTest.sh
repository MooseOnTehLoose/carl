#!/bin/bash

blocks=512
if ! [ -z "$1" ]; then
    blocks=$1
fi
while true 
do
    echo -e "nvidia-smi: \n"
    nvidia-smi
    echo -e "\ncalculate pi: \n"
    /opt/carl/cudaPi $blocks
    sleep 60
done
