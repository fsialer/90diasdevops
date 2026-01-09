#!/bin/bash
# setup-s3-demo.sh

echo "🚀 Configurando demo de S3..."

# Crear buckets
#awslocal s3 mb s3://roxs-demo
aws --endpoint-url=http://localhost:4566 s3 mb s3://roxs-demo
#awslocal s3 mb s3://roxs-web
aws --endpoint-url=http://localhost:4566 s3 mb s3://roxs-web

# Crear archivos de prueba
echo "Demo de LocalStack S3" > demo.txt
echo '{"message": "Hello from LocalStack!"}' > data.json

# Crear sitio web simple
cat > index.html << EOF
<!DOCTYPE html>
<html>
<head><title>LocalStack S3 Demo</title></head>
<body>
    <h1>🚀 LocalStack S3 Demo</h1>
    <p>Este sitio está en S3 simulado!</p>
    <a href="data.json">Ver datos JSON</a>
</body>
</html>
EOF

# Subir archivos
#awslocal s3 cp demo.txt s3://roxs-demo/
aws --endpoint-url=http://localhost:4566 s3 cp demo.txt s3://roxs-demo/
#awslocal s3 cp data.json s3://roxs-demo/
aws --endpoint-url=http://localhost:4566 s3 cp data.json s3://roxs-demo/
#awslocal s3 cp index.html s3://roxs-web/
aws --endpoint-url=http://localhost:4566 s3 cp index.html s3://roxs-web/

# Configurar hosting web
#awslocal s3 website s3://roxs-web --index-document index.html
aws --endpoint-url=http://localhost:4566 s3 website s3://roxs-web/ --index-document index.html

echo "✅ Demo configurado!"
echo "🌐 Sitio web: http://localhost:4566/roxs-web/index.html"
echo "📄 Datos: http://localhost:4566/roxs-demo/data.json"