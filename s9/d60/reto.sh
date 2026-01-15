# --- RETO ---
aws --endpoint-url=http://localhost:4566 s3 mb s3://roxs-input
aws --endpoint-url=http://localhost:4566 s3 mb s3://roxs-reports

echo "hola mundo esto es una prueba de s3 a lambda" > archivo.txt
aws --endpoint-url=http://localhost:4566 s3 cp archivo.txt s3://roxs-input/archivo.txt


aws --endpoint-url=http://localhost:4566 lambda create-function     --function-name file-processor \
   --runtime python3.9 \
   --role arn:aws:iam::000000000000:role/lambda-role \
   --handler file_processor.lambda_handler  \
   --zip-file fileb://file_processor.zip

aws --endpoint-url=http://localhost:4566 lambda invoke \
  --function-name file-processor \
  --payload '{
    "source_bucket": "roxs-input",
    "source_key": "archivo.txt",
    "report_bucket": "roxs-reports"
  }' \
  --cli-binary-format raw-in-base64-out \
  response.json
