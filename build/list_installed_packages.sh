#!/bin/bash

# https://wiki.debian.org/ListInstalledPackages

dpkg-query -f '${binary:Package}\n' -W

