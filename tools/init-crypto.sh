#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

project_id="${PROJECT_ID:?Set the Google Cloud Project ID}"

gcloud kms keyrings create vault \
  --location global \
  --project ${project_id}

gcloud kms keys create vault-init \
  --location global \
  --keyring vault \
  --purpose encryption \
  --project ${project_id}
