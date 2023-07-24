#!/bin/bash

set -eu

deployment=rp-unbrk-rainbowbridge
namespace=rpay-dev-tools

podname=$(kubectl -n $namespace get pods --selector=app=$deployment -o jsonpath='{.items[*].metadata.name}')

if [[ ${podname} ]]; then
    kubectl -n $namespace exec -it "${podname}" -- bash
else
    echo "Error getting podname"
    echo "${podname}"
fi
