#!/usr/bin/env bash

if [[ "${DEBUG:-false}" = true ]]; then
    set -x
fi

set -euo pipefail

this="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
. "$this/SETUP.sh"


if [ -z ${CI+x} ]; then 
    # shellcheck disable=SC1091
    . "$this/../../gcp-scripts/common.sh"

    if [[ $(gcloud auth print-access-token 2>&1) == *"Reauthentication required"* ]]; then        
        echo "The gcloud auth token is expired or invalid. Please perform a new login."
        gcp_login
    else
        echo "The gcloud auth token is still valid."
        gcloud config set project $GCP_PROJECT
        gcloud container clusters get-credentials $GCP_CLUSTER --zone $GCP_ZONE --project $GCP_PROJECT
    fi
    export -f prompt
fi


"$this/../../deploy_helper.sh" deploy_all