#!/usr/bin/env bash

cicd=(
  concourse-common
  flow
  flow-docker-pipeline
)

jda0041=(
  HRImgMove
  gcp-cloudsql-boot
  reset-me
  spring-mvc-proto
)

PasswordReset=(
  PasswordReset
  pwr-cf-nginx-proxy
  pwr-deployment-scripts
)

CommonTax=(
  CommonTaxService
  tax-cf-nginx-proxy
)

######################################## End of repo list ########################################
# set +e
# set -x

WORKSPACE_DIR="/Users/jda0041/Workspaces"
GITHUB_URL="https://github.homedepot.com"

if test ! $(which git); then
  echo "Git is not installed"
  exit 1
fi

function clone {
  ORG=$1
  shift
  mkdir -p ${WORKSPACE_DIR}/${ORG}
  for repo in $@;
  do
    LOCAL_DIR=${WORKSPACE_DIR}/${ORG}/${repo}
    REPO_URL="${GITHUB_URL}/${ORG}/${repo}.git"
    echo "Cloning ${REPO_URL} into ${LOCAL_DIR}"
    git clone ${REPO_URL} ${LOCAL_DIR}
  done
}

clone 'ci-cd' ${cicd[@]}
clone 'jda0041' ${jda0041[@]}
clone 'PasswordReset' ${PasswordReset[@]}
clone 'CommonTax' ${CommonTax[@]}
