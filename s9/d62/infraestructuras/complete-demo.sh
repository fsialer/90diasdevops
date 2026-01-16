#!/bin/bash
# complete-demo.sh

echo "🚀 Demo de arquitectura completa LocalStack"
echo "=========================================="

API_URL="http://localhost:4566/restapis/$api_id/prod/_user_request_"

echo "1. 📊 Estado inicial del sistema"
curl -s "$API_URL/stats" | jq

echo -e "\n2. 📸 Subiendo nueva imagen..."
echo "Nueva imagen para procesar: $(date)" > new-demo-image.jpg
#awslocal s3 cp new-demo-image.jpg s3://roxs-images-original/
aws --endpoint-url=http://localhost:4566 s3 cp new-demo-image.jpg s3://roxs-images-original/

echo -e "\n3. ⚡ Procesando imagen con Lambda..."
#awslocal lambda invoke \
#    --function-name roxs-image-processor \
#    --payload '{
#        "bucket": "roxs-images-original",
#        "key": "new-demo-image.jpg"
#    }' \
#    demo-process-result.json > /dev/null
aws --endpoint-url=http://localhost:4566 lambda invoke \
    --function-name roxs-image-processor \
    --payload '{
        "bucket": "roxs-images-original",
        "key": "new-demo-image.jpg"
    }' \
    --cli-binary-format raw-in-base64-out \
    demo-process-result.json > /dev/null

echo "Resultado del procesamiento:"
cat demo-process-result.json | jq

echo -e "\n4. 📝 Generando logs de aplicación..."
# awslocal lambda invoke \
#     --function-name roxs-log-processor \
#     --payload '{
#         "logs": [
#             {
#                 "level": "INFO",
#                 "message": "Image processing completed successfully",
#                 "service": "image-processor",
#                 "user_id": "demo-user"
#             },
#             {
#                 "level": "DEBUG",
#                 "message": "Thumbnail generated and stored",
#                 "service": "image-processor", 
#                 "user_id": "demo-user"
#             }
#         ]
#     }' \
#     demo-logs-result.json > /dev/null
aws --endpoint-url=http://localhost:4566 lambda invoke \
    --function-name roxs-log-processor \
    --payload '{
        "logs": [
            {
                "level": "INFO",
                "message": "Image processing completed successfully",
                "service": "image-processor",
                "user_id": "demo-user"
            },
            {
                "level": "DEBUG",
                "message": "Thumbnail generated and stored",
                "service": "image-processor", 
                "user_id": "demo-user"
            }
        ]
    }' \
    --cli-binary-format raw-in-base64-out \
    demo-logs-result.json > /dev/null
echo "Logs procesados exitosamente"

echo -e "\n5. 🔔 Enviando notificación de completitud..."
curl -s -X POST "$API_URL/notifications" \
    -H "Content-Type: application/json" \
    -d '{
        "title": "Procesamiento completado",
        "message": "La imagen new-demo-image.jpg fue procesada exitosamente",
        "priority": "normal"
    }' | jq

echo -e "\n6. 📊 Estado final del sistema"
curl -s "$API_URL/stats" | jq

echo -e "\n7. 🔍 Verificando resultados..."
echo "Imágenes procesadas:"
curl -s "$API_URL/images" | jq '.count'

echo "Logs en el sistema:"
curl -s "$API_URL/logs" | jq '.total_scanned'

echo "Archivos en S3:"
#awslocal s3 ls s3://roxs-images-original/ | wc -l
aws --endpoint-url=http://localhost:4566 s3 ls s3://roxs-images-original/ | wc -l

echo -e "\n✅ Demo completo - Todos los servicios integrados funcionando!"