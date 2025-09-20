#!/bin/bash
kubectl get pods -n voting-app
kubectl get services -n voting-app
kubectl logs deployment/worker -n voting-app