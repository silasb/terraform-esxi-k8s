#!/bin/bash

#COREOS_VERSION=$(curl -sSL https://stable.release.core-os.net/amd64-usr/current/version.txt | grep COREOS_VERSION_ID | sed 's/COREOS_VERSION_ID=//')
curl -C - -LO https://stable.release.core-os.net/amd64-usr/current/coreos_production_vmware_ova.ova
