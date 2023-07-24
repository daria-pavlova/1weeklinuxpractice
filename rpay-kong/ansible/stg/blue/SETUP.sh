#!/usr/bin/env bash

set -euo pipefail

if [ -z ${VERSION+x} ]; then
  export VERSION=$(git rev-parse --short=8 HEAD)
fi
this="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export this
### env specific vars
export ENVIRONMENT="stg"
export COLOR="blue"
export SERVICE="rpay"
export TIMESTAMP=$(date +%Y%m%d%H%M%S)
# export SECRETS_FILE="secrets.yaml"
export INVENTORY_FILE="$this/../inventory$ENVIRONMENT.ini"
export KONG_BACKUP="/etc/kong/$SERVICE/$COLOR/kong.yaml.bak"
export KONG_NEW="/etc/kong/$SERVICE/$COLOR/kong-$TIMESTAMP.yaml"
export config=$this/kong.yaml
export ENDPOINT="http://localhost"

