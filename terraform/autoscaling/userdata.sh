#!/bin/bash -v
sudo mkfs -t xfs /dev/sdb
sudo mount /dev/sdb /var/log
sudo chmod 777 /var/log