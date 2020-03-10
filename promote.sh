#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

export CREATED_TIME=$(date '+%a-%b-%d-%Y-%H-%M-%S')
export LOCAL_BRANCH_NAME="changes-${CREATED_TIME,,}"

echo "creating branch $LOCAL_BRANCH_NAME"

# lets setup git
jx step git credentials

git config --global --add user.name JenkinsXBot
git config --global --add user.email jenkins-x@googlegroups.com


mkdir -p /tmp/docgen
pushd /tmp/docgen
  export DOC_GEN_VERSION="0.0.2"
  echo "downloading cli-doc-gen version $DOC_GEN_VERSION"
  curl -L https://github.com/jenkins-x-labs/cli-doc-gen/releases/download/v$DOC_GEN_VERSION/cli-doc-gen-linux-amd64.tar.gz | tar xzv
popd

git clone https://github.com/jenkins-x/jx-docs.git

pushd jx-docs
  git checkout -b $LOCAL_BRANCH_NAME
popd

pushd /tmp
  git clone https://github.com/jenkins-x-labs/cloud-resources.git
popd

MESSAGE="chore: updated GCP cloud resources docs"

pushd jx-docs/layouts/shortcodes
  /tmp/docgen/cli-doc-gen -f /tmp/cloud-resources/gcloud/create_cluster.sh -o gcp-create-cluster.html
  /tmp/docgen/cli-doc-gen -f /tmp/cloud-resources/gcloud/setup_resources.sh -o gcp-create-resources.html --trim-prefix="retry "
  /tmp/docgen/cli-doc-gen -f /tmp/cloud-resources/kind/create_cluster.sh -o kind-create-cluster.html

  git add *
  git commit --allow-empty -a -m "$MESSAGE"
popd

pushd jx-docs
  git push origin $LOCAL_BRANCH_NAME
  jx create pullrequest -t "$MESSAGE" -l updatebot
popd

echo "created Pull Request"