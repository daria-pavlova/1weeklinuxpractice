#!/usr/bin/env bash

if [[ "${DEBUG:-false}" = true ]]; then
    set -x
fi

set -euo pipefail

this="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "$this/SETUP.sh"
. "$this/../../roc/roc-scripts/common.sh"

if [ -z ${VERSION+x} ]; then
  VERSION=$(git rev-parse --short=8 HEAD)
fi

export -f prompt

echo "Base directory: $this"
echo "Environment: $ENVIRONMENT"


if prompt "Install kong"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../play-books/1_install_kong.yml" 
fi

if prompt "Install kong services"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../play-books/1_install_kong_services.yml" 
fi

if prompt "Install haproxy"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../play-books/2_install_haproxy.yml" 
fi

if prompt "Install filebeat"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../play-books/4_logging.yml"
fi



