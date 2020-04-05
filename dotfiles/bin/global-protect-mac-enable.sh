#!/usr/bin/env bash

# derived from here: https://git.io/JvBgt

set -uf

launchctl load -w /Library/LaunchAgents/com.paloaltonetworks.gp.pangpa.plist
launchctl load -w /Library/LaunchAgents/com.paloaltonetworks.gp.pangps.plist
