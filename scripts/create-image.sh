#!/bin/bash

set -e

function log() {
  YELLOW='\033[0;33m'
  NC='\033[0m' # No Color
  echo -e "$YELLOW$@$NC"
}

function logerror() {
  RED='\033[0;31m'
  NC='\033[0m' # No Color
  echo -e "$RED$@$NC"
}

function logwarn() {
  PURPLE='\033[0;35m'
  NC='\033[0m' # No Color
  echo -e "$PURPLE$@$NC"
}

function retry() {
  local n=1
  local max=5
  while true; do
    "$@" && break || {
      if [[ $n -lt $max ]]; then
        ((n++))
        logwarn "Command failed. Attempt $n/$max:"
      else
        logerror "The command has failed after $n attempts."
        return 1
      fi
    }
  done
}

CCLOUD_VERSION=$(ccloud --version | cut -d " " -f 3)
retry docker build -t vdesabou/docker-ccloud:$CCLOUD_VERSION .

docker push vdesabou/docker-ccloud:$CCLOUD_VERSION
docker tag vdesabou/docker-ccloud:$CCLOUD_VERSION vdesabou/docker-ccloud:latest
docker push vdesabou/docker-ccloud:latest