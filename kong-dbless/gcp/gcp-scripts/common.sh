#!/usr/bin/env bash

prompt() {
    read -p "$1 ? [y/n] " answer
    case ${answer:0:1} in
        y|Y )
            return 0
        ;;
        * )
            return 1
        ;;
    esac
}

gcp_login() {

    if [ -z ${GCP_PROJECT+x} ]; then
        echo "PROJECT not defined. Exiting..."
        exit 1
    fi

    if [ -z ${GCP_CLUSTER+x} ]; then
        echo "CLUSTER not defined. Exiting..."
        exit 1
    fi

    if [ -z ${GCP_ZONE+x} ]; then
        echo "ZONE not defined. Exiting..."
        exit 1
    fi

    echo "Logging into $GCP_PROJECT/$GCP_CLUSTER/$GCP_ZONE..."

    gcloud auth login
    gcloud config set project $GCP_PROJECT
    gcloud container clusters get-credentials $GCP_CLUSTER --zone $GCP_ZONE --project $GCP_PROJECT

    echo
}

gcp_registry_login() {

    if [ -z ${GCP_PROJECT+x} ]; then
        echo "PROJECT not defined. Exiting..."
        exit 1
    fi

    if [ -z ${GCP_CLUSTER+x} ]; then
        echo "CLUSTER not defined. Exiting..."
        exit 1
    fi

    if [ -z ${GCP_ZONE+x} ]; then
        echo "ZONE not defined. Exiting..."
        exit 1
    fi

    echo "Logging into $GCP_PROJECT/$GCP_CLUSTER/$GCP_ZONE..."

    gcloud auth login
    gcloud config set project $GCP_PROJECT
    gcloud auth configure-docker
}
#### end of common functions ####
