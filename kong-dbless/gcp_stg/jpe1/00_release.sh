#!/bin/sh

set -o errexit
set -o nounset
set -o xtrace

cd "$(dirname "$0")"

gcloud container clusters get-credentials "stg-jpe1-01" --zone "asia-northeast1" --project "r-pay-1"

kubectl apply -f .