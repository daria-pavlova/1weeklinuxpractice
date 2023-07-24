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

if prompt "Check current deployment"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../../play-books/3_blue_green.yml" --tags "check-deploy"\
        --extra-vars color=$COLOR 
fi

if prompt "Copy new config"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../../play-books/3_blue_green.yml" --tags "copy-kong"\
        --extra-vars timestamp=$TIMESTAMP \
        --extra-vars version=$VERSION \
        --extra-vars color=$COLOR \
        --extra-vars kong_backup=$KONG_BACKUP \
        --extra-vars kong_new=$KONG_NEW
fi

if prompt "Verify new config"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../../play-books/3_blue_green.yml"  --tags "verify" \
        --extra-vars color=$COLOR \
        --extra-vars kong_backup=$KONG_BACKUP \
        --extra-vars kong_new=$KONG_NEW
fi


if prompt "Diff kong.yaml"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../../play-books/3_blue_green.yml" --tags "diff-kong"\
        --extra-vars timestamp=$TIMESTAMP \
        --extra-vars version=$VERSION \
        --extra-vars color=$COLOR \
        --extra-vars kong_backup=$KONG_BACKUP \
        --extra-vars kong_new=$KONG_NEW
fi

if prompt "Do you want to update kong configuration"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../../play-books/3_blue_green.yml" --tags "update","update-reload" \
        --extra-vars color=$COLOR \
        --extra-vars kong_backup=$KONG_BACKUP \
        --extra-vars kong_new=$KONG_NEW
fi

if prompt "Do you want to switch traffic to $COLOR"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../../play-books/3_blue_green.yml" --tags "switch" \
        --extra-vars color=$COLOR \
        --extra-vars endpoint=$ENDPOINT
fi

if prompt "Check kong connection"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../../play-books/3_blue_green.yml" --tags "check-kong" \
        --extra-vars color=$COLOR \
        --extra-vars endpoint=$ENDPOINT
fi

if prompt "Do you want to rollback"; then
    ansible-playbook -i "$INVENTORY_FILE" \
        "$this/../../play-books/3_blue_green.yml" --tags "rollback","update-reload" \
        --extra-vars color=$COLOR \
        --extra-vars endpoint=$ENDPOINT \
        --extra-vars kong_backup=$KONG_BACKUP 
fi

