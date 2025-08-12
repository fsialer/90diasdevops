#!/bin/bash
REPLICAS=${1:-2}
echo "🔄 Escalando aplicación a $REPLICAS réplicas"
terraform apply -var="replica_count=$REPLICAS" -auto-approve