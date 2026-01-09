#!/bin/bash
# s3-stats.sh

echo "📊 Estadísticas de S3 LocalStack"
echo "================================"

echo "🗂️  Buckets totales:"
awslocal s3 ls | wc -l

echo ""
echo "📦 Lista de buckets:"
awslocal s3 ls

echo ""
echo "📄 Archivos por bucket:"
for bucket in $(awslocal s3 ls | awk '{print $3}'); do
    count=$(awslocal s3 ls s3://$bucket --recursive | wc -l)
    echo "  $bucket: $count archivos"
done

echo ""
echo "🔗 URLs de ejemplo:"
awslocal s3 ls s3://roxs-bucket --recursive | head -3 | while read line; do
    key=$(echo $line | awk '{print $4}')
    echo "  http://localhost:4566/roxs-bucket/$key"
done