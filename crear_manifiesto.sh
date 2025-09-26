#!/bin/bash
# Deployment
cat > k8s/deployment.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: arc-demo-app
  labels:
    app: arc-demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: arc-demo
  template:
    metadata:
      labels:
        app: arc-demo
    spec:
      containers:
      - name: app
        image: nginx:alpine
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "50m"
          limits:
            memory: "128Mi"
            cpu: "100m"
EOF

# Service
cat > k8s/service.yaml << EOF
apiVersion: v1
kind: Service
metadata:
  name: arc-demo-service
spec:
  selector:
    app: arc-demo
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
  type: NodePort
EOF

