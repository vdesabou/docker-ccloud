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

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# download ccloud to get latest version
retry curl --http1.1 -L https://cnfl.io/ccloud-cli | sh -s -- -b $PWD
latest_version=$($PWD/ccloud --version | cut -d " " -f 3)
rm -f $PWD/ccloud

for version in $(curl -L https://cnfl.io/ccloud-cli | sh -s -- -l)
do
  if [[ "$version" = "latest" ]]
  then
      log "Version $version, skipping.."
      continue
  fi

  set +e
  ${DIR}/docker-image-exists.sh vdesabou/docker-ccloud:$version
  ret=$?
  if [ $ret -eq 0 ]
  then
    log "Version $version already existing, skipping.."
  else
    # add v before version
    retry docker build -t vdesabou/docker-ccloud:$version .
    ret=$?
    set -e
    if [ $ret -eq 0 ]
    then
      log "Pushing version $version"
      docker push vdesabou/docker-ccloud:$version

      if [[ "$version" = "$latest_version" ]]
      then
        log "Pushing version $version as latest"
        docker tag vdesabou/docker-ccloud:$version vdesabou/docker-ccloud:latest
        docker push vdesabou/docker-ccloud:latest
      fi
    else
      logwarn "Failed to build version $version"
    fi
  fi
done

exit 0
