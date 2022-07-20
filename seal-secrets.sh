#!/bin/bash

usage() {
  echo "USAGE: ./seal-secrets.sh <SERVICE_NAME> <NAMESPACE>"
  echo ""
  echo "ARGS:"
  echo "Example:
  ./seal-secrets.sh node-svc sandbox-ns
  ./seal-secrets.sh node-svc dev-ns 
  ./seal-secrets.sh node-svc staging-ns
  ./seal-secrets.sh node-svc production-ns
  "
  exit 0
}

if [ "${#@}" -lt "2" ] || [ "${#@}" -gt "3" ]; then
  usage
fi

SERVICE_NAME=${1}
NAMESPACE=${2}

echo "Can you confirm that the following cluster is the right cluster for this secret: "
kubectl config view --minify --flatten | grep current-context
echo "Enter 'yes' to continue or 'no' to stop: "
read input
if [ "$input" == "yes" ]
then
echo "Proceeding to create sealed secrets..."
kubeseal --raw --controller-name=sealed-secrets --controller-namespace=kube-system --name ${SERVICE_NAME} --namespace ${NAMESPACE}
fi
