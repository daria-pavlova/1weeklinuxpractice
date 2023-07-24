#!/bin/bash

set -euo pipefail

export BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export CI_PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export GCP_PROJECT="r-pay-1"
export GCP_CLUSTER="prod-jpe2-01"
export GCP_ZONE="asia-northeast2"

