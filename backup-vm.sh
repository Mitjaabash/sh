#!/bin/bash
dd if=/var/lib/libvirt/images/server2.img | gzip -kc -3 > ~/backup/server2.img.gz
