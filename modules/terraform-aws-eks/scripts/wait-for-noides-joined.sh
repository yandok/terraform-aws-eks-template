#!/bin/bash
set -o errexit
set -o nounset
counter=0
export KUBECONFIG=kubeconfig_$1-$2-eks
until [ $counter -ge $3 ]
do
  sleep 1;
  counter=$(kubectl get nodes | grep -v NAME | wc -l)
  echo Nodes-Joined: $counter
done
