#!/usr/bin/env bash

if [[ "${DEBUG:-false}" = true ]]; then
    set -x
fi

set -euo pipefail

this="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "$this/SETUP.sh"
. "$this/../../../roc/roc-scripts/common.sh"

export -f prompt

echo "Base directory: $this"
echo "Environment: $ENVIRONMENT"

rollback(){
    if prompt "Do you want to rollback"; then
        ansible-playbook -i "$INVENTORY_FILE" \
            "$this/../../play-books/3_blue_green.yml" --tags "rollback","update-reload" \
            --extra-vars color=$COLOR \
            --extra-vars endpoint=$ENDPOINT \
            --extra-vars kong_backup=$KONG_BACKUP 
    fi
}

case ${1} in
rollback) rollback ;;
*)
    echo "Function not implemented."
    exit 1
    ;;
esac
