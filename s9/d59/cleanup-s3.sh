#!/bin/bash
# cleanup-s3.sh

echo "🧹 Limpiando S3 LocalStack..."

# Eliminar todos los archivos de todos los buckets
for bucket in $(awslocal s3 ls | awk '{print $3}'); do
    echo "Limpiando bucket: $bucket"
    awslocal s3 rm s3://$bucket --recursive
    awslocal s3 rb s3://$bucket
done

echo "✅ Limpieza completa!"