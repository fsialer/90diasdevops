#!/bin/bash
# Rollback en cualquier ambiente
kubectl rollout undo deployment/mi-app -n dev
kubectl rollout undo deployment/mi-app -n staging
kubectl rollout undo deployment/mi-app -n prod