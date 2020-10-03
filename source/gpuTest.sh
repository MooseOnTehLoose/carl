#!/bin/bash
nvidia-smi | tee /opt/carl/nvidia-smi.txt
./cudaPi 16384 | tee /opt/carl/cudaPi.txt
sleep 900
