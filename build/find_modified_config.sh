#!/bin/bash

# from http://serverfault.com/questions/90400/how-to-check-for-modified-config-files-on-a-debian-system
dpkg-query -W -f='${Conffiles}\n' '*' | awk 'OFS="  "{print $2,$1}' | LANG=C md5sum -c 2>/dev/null | awk -F': ' '$2 !~ /OK$/{print $1}' | sort

