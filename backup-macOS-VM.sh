#!/bin/bash
set -e
vmrun stop /home/michael/vmware/macOS/macOS.vmx
set +e
rsync -az /home/michael/vmware/macOS /backup/macOS-VM
vmrun start /home/michael/vmware/macOS/macOS.vmx nogui
