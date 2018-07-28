#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

forge --profile=default deploy
