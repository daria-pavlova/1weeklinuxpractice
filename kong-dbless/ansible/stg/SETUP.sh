#!/usr/bin/env bash

set -euo pipefail

if [ -z ${VERSION+x} ]; then
  export VERSION=$(git rev-parse --short=8 HEAD)
fi
export TIMESTAMP=$(date +%Y%m%d%H%M%S)
export ENVIRONMENT="stg"
export SECRETS_FILE="secrets.yaml"
export INVENTORY_FILE="$this/inventory$ENVIRONMENT.ini"
export SERVICE="rpay"
export ENVIRONMENT="stg"
export ENDPOINT="stg-kong-101.rpay-dev.jpe2b.dcnw.rakuten"