#!/bin/bash
function check_deps() {
  test -f $(which jq) || error_exit "jq command not detected in path, please install it"
}
function parse_input() {
  eval "$(jq -r '@sh "export HOST=\(.host)"')"
  if [[ -z "${HOST}" ]]; then export HOST=none; fi
}
function return_token() {
  USER_AUTH=$(ssh -oStrictHostKeyChecking=no core@$HOST -q "/opt/bin/kubectl config view -ojson --raw | jq '.users[].user'")
  CLUSTER_AUTH=$(ssh -oStrictHostKeyChecking=no core@$HOST -q "/opt/bin/kubectl config view -ojson --raw | jq '{ \"certificate-authority-data\": .clusters[].cluster.\"certificate-authority-data\" }'")

  echo $USER_AUTH > /tmp/user_auth.txt
  echo $CLUSTER_AUTH > /tmp/cluster_auth.txt

  jq -n \
    --argjson user_auth "$USER_AUTH" \
    --argjson cluster_auth "$CLUSTER_AUTH" \
    '[$user_auth, $cluster_auth] | add'
}
check_deps && \
parse_input && \
sleep 10 && \
return_token