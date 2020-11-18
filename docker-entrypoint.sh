#!/bin/bash
/etc/init.d/ssh start > /dev/null
/etc/init.d/docker start > /dev/null
sudo -u altis "$@"
