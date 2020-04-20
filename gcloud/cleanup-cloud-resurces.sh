#!/usr/bin/env bash
set -e
set -x

# CLI-DOC-GEN-START
gcloud iam service-accounts delete $CLUSTER_NAME-ex@$PROJECT_ID.iam.gserviceaccount.com
gcloud iam service-accounts delete $CLUSTER_NAME-jb@$PROJECT_ID.iam.gserviceaccount.com
gcloud iam service-accounts delete $CLUSTER_NAME-st@$PROJECT_ID.iam.gserviceaccount.com
gcloud iam service-accounts delete $CLUSTER_NAME-tk@$PROJECT_ID.iam.gserviceaccount.com
gcloud iam service-accounts delete $CLUSTER_NAME-vo@$PROJECT_ID.iam.gserviceaccount.com
gcloud iam service-accounts delete $CLUSTER_NAME-vt@$PROJECT_ID.iam.gserviceaccount.com
# CLI-DOC-GEN-END