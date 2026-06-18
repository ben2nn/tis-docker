#!/bin/bash
set -e

# Fix volume permissions (running as root at this point)
mkdir -p /opt/data /opt/logs/tis
chown -R tis:tis /opt/data /opt/logs

# Drop to tis user and start TIS
exec gosu tis /opt/app/tis-uber/bin/tis start
