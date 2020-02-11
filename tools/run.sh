#!/bin/bash

# Use the Unofficial Bash Strict Mode (Unless You Looove Debugging)
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail

IFS=$'\n\t'

RUNNER_HOME_DIR="/home/runner/app"

function configure_permissions_for_runner() {
    # Ensure that assigned uid has entry in /etc/passwd.
    if touch /etc/passwd && [ "$(id -u)" -ge 10000 ]; then
        echo "Patching /etc/passwd to make ${RUNNER_USER} -> builder and $(id -u) -> ${RUNNER_USER}"
        sed -e "s/${RUNNER_USER}/builder/g" > /tmp/passwd < /etc/passwd
        echo "${RUNNER_USER}:x:$(id -u):$(id -g):,,,:/home/${RUNNER_USER}:/bin/bash" >> /tmp/passwd
        cat /tmp/passwd > /etc/passwd
        rm /tmp/passwd
    fi
}

configure_permissions_for_runner

java "-XX:+ExitOnOutOfMemoryError" -jar "${RUNNER_HOME_DIR}/app.jar" "$@"