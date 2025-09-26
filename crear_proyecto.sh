#!/bin/bash
mkdir k8s-arc-demo && cd k8s-arc-demo

# Crear estructura
mkdir -p .github/workflows k8s

# Crear Dockerfile simple
cat > Dockerfile << EOF
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
EXPOSE 80
EOF

# Crear página web
cat > index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>ARC Demo</title>
    <style>
        body { font-family: Arial; text-align: center; padding: 50px; }
        h1 { color: #326CE5; }
        .container { max-width: 600px; margin: 0 auto; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Desplegado con ARC</h1>
        <p>Esta aplicación se desplegó usando GitHub Actions Runners en Kubernetes!</p>
        <p><strong>Timestamp:</strong> $(date)</p>
    </div>
</body>
</html>
EOF