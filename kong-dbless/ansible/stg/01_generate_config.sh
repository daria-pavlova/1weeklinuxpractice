#!/usr/bin/env bash

if [[ "${DEBUG:-false}" = true ]]; then
    set -x
fi

set -euo pipefail

this="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo $this
. "$this/../../roc/roc-scripts/common.sh"

ENVIRONMENT="stg"
SECRETS_FILE="secrets.yaml"
INVENTORY_FILE="$this/inventory$ENVIRONMENT.ini"
export -f prompt

echo "Base directory: $this"
echo "Environment: $ENVIRONMENT"

if prompt "Do you want to generate kong.yaml config"; then
    bash "$this/../../roc/dev/jpe2b/config/10_generate.sh"
fi


if prompt "Do you want to copy kong.yaml to $ENVIRONMENT dicretory"; then
    cp $this/../../roc/dev/jpe2b/config/kong.yaml $this/.
fi