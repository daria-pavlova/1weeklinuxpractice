#!/bin/bash

set -euo pipefail

if [[ "${DEBUG:-false}" = true ]]; then
    set -x
fi
# if CI is true or TRUE echo Running in CI
if [ -z ${CI+x} ]; then
    echo "Running locally"
else
    echo "Running in CI"
fi

tmp_manifest="$(mktemp)"

clean_tmp_manifest() {
    LAST_COMMAND_EXIT_STATUS=$?
    if [ -z ${CI+x} ]; then
        if [ $LAST_COMMAND_EXIT_STATUS -ne 0 ]; then
            if prompt "Do you want to clean the temporary manifest"; then
                rm -f "$tmp_manifest"
                echo "$tmp_manifest has been removed"
            fi
        else
            rm -f "$tmp_manifest"
            echo "$tmp_manifest has been removed"
        fi
    else
        echo "CI::Last command exit status: $LAST_COMMAND_EXIT_STATUS"
    fi
    exit $LAST_COMMAND_EXIT_STATUS
}

trap clean_tmp_manifest EXIT


replace_vars() {
    filepath=$1
    TIMESTAMP=$(date +%s)
    tmp_manifest=$(mktemp) # Create a temporary file for the modified manifest

    sed -e "
        s|\${ENV}|${ENV:-}|g
        s|\${BRANCH_NAME}|${BRANCH_NAME:-}|g 
        s|\${TENANT_NAMESPACE}|${TENANT_NAMESPACE:-}|g 
        s|\${CAAS_CLUSTER}|${CAAS_CLUSTER:-}|g 
        s|\${DEPLOYMENT_NAME}|${DEPLOYMENT_NAME:-}|g 
        s|\${PROJECT}|${PROJECT:-}|g 
        s|\${DEPLOYMENT_ECHO}|${DEPLOYMENT_ECHO:-}|g 
        s|\${DOCKER_ECHO_IMAGE}|${DOCKER_ECHO_IMAGE:-}|g 
        s|\${DOCKER_KONG_IMAGE}|${DOCKER_KONG_IMAGE:-}|g 
        s|\${DOCKER_IMAGE}|${DOCKER_IMAGE:-}|g 
        s|\${TIMESTAMP}|$TIMESTAMP|g 
        s|\${VERSION}|${VERSION:-}|g
        s|\${K8S_KONG_CONFIG_YAML_DESTINATION}|${K8S_KONG_CONFIG_YAML_DESTINATION:-}|g
        s|\${K8S_KONG_CONFIG_YAML_DESTINATION_DIR}|${K8S_KONG_CONFIG_YAML_DESTINATION_DIR:-}|g
        s|\${K8S_KONG_CONFIG_YAML_DESTINATION_FILE}|${K8S_KONG_CONFIG_YAML_DESTINATION_FILE:-}|g
    " "$filepath" > "$tmp_manifest"

    echo "$tmp_manifest"
}

deploy(){
    deployfile=$(replace_vars "$1")
    kubectl apply -f "$deployfile" -n "$TENANT_NAMESPACE"
}

destroy(){
    deployfile=$(replace_vars "$1")
    kubectl delete -f "$deployfile" -n "$TENANT_NAMESPACE"
}

status_check(){
    deployfile=$(replace_vars "$1")
    if grep -q "kind: Deployment" "$deployfile"; then
        kubectl rollout status -w "deployment/${DEPLOYMENT_NAME}" --timeout 3m -n "$TENANT_NAMESPACE"
    fi
}

deploy_kong_config_map(){
    # create kong config map name kong-config-$VERSION
    kubectl create configmap "kong-config-$ENV-$VERSION" --from-file="$KONG_CONFIG_YAML_SOURCE" -n "$TENANT_NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -
}

destroy_kong_config_map(){
    # create kong config map name kong-config-$VERSION
    kubectl create configmap "kong-config-$ENV-$VERSION" --from-file="$KONG_CONFIG_YAML_SOURCE" -n "$TENANT_NAMESPACE" --dry-run=client -o yaml | kubectl delete -f -
}

deploy_prompt() {
    filepath=$1
    filename="$(basename "$filepath")"
    if prompt "Do you want to deploy $filename to k8s"; then
        deploy "$filepath" 
        status_check "$filepath"
    fi
}

destroy_prompt() {
    filepath=$1
    filename="$(basename "$filepath")"
    if prompt "Do you want to delete $filename"; then
        destroy "$filepath"
    fi
}

deploy_all(){
    if prompt "Do you want to deploy kong config map"; then
        deploy_kong_config_map
    fi
    for filepath in $MANIFEST_SOURCE/*
    do
        if [ -z ${CI+x} ]; then
            deploy_prompt "$filepath"
        else
            deploy "$filepath"
            if [[ "$TENANT_NAMESPACE" != *"stg" && "$TENANT_NAMESPACE" != *"qa" && "$TENANT_NAMESPACE" != *"prod" ]]; then 
                get_service_vs_hostname "$filepath"
            fi
            status_check "$filepath"
        fi
    done
}

destroy_all(){
    if prompt "Do you want to destroy kong config map"; then
        destroy_kong_config_map
    fi
    for filepath in $MANIFEST_SOURCE/*
    do
        if [ -z ${CI+x} ]; then
            destroy_prompt "$filepath" 
        else
            destroy "$filepath" 
        fi
    done
}

case ${1} in
deploy_all) deploy_all ;;
destroy_all) destroy_all ;;
*)
    echo "Function not implemented."
    exit 1
    ;;
esac
