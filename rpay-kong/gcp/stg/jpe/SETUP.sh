#!/bin/bash

set -euo pipefail

export REGION="jpe"

BRANCH_NAME=${CI_COMMIT_REF_SLUG:-$(git rev-parse --abbrev-ref HEAD)}
if [ -z ${CI_PIPELINE_ID+x} ]; then
  export VERSION=${CI_COMMIT_SHORT_SHA:-$(git rev-parse --short=8 HEAD)-local}
else
  export VERSION=${CI_COMMIT_SHORT_SHA:-$(git rev-parse --short=8 HEAD)}_${CI_PIPELINE_ID}
fi
VERSION=$(git rev-parse --short=8 HEAD)
export VERSION
export BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CI_PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export CI_PROJECT_DIR

export GCP_PROJECT="r-pay-1"
export GCP_CLUSTER="stg-jpe1-01"
export GCP_ZONE="asia-northeast1"
export DOCKER_IMAGE_REPO="asia.gcr.io/r-pay-1/rpay-kong"
export DOCKER_IMAGE_TAG="$VERSION"
export DOCKER_IMAGE="$DOCKER_IMAGE_REPO:04387659"
export GCP_NAMESPACE=rpay-kong

export BASE_DIR
export BRANCH_NAME
export ENV=stg
export REGION=jpe2b
export TENANT_NAMESPACE=rpay-kong
export DEPLOYMENT_NAME="$ENV-rpay-kong"
export DOCKER_DEFAULT_PLATFORM=linux/amd64
export PROJECT="kong"
export DOCKER_KONG_IMAGE=$DOCKER_IMAGE
export DOCKER_IMAGE=$DOCKER_KONG_IMAGE

KONG_CONFIG_YAML_SOURCE="$this/config/kong.yaml"
export KONG_CONFIG_YAML_SOURCE

#k8s specific configs for kong
export K8S_KONG_CONFIG_YAML_DESTINATION_FILE="kong.yaml"
export K8S_KONG_CONFIG_YAML_DESTINATION_DIR="/kong/declarative"
export K8S_KONG_CONFIG_YAML_DESTINATION="/kong/declarative/kong.yaml"
export MANIFEST_SOURCE="$this/k8s"