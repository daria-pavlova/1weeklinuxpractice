#!/bin/bash

set -eu

this="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$this/SETUP.sh"
. "$CI_PROJECT_DIR/common.sh"

gcp_login
