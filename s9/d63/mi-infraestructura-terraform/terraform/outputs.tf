# Mostrar información importante después del despliegue

output "resumen_infraestructura" {
  description = "Resumen de la infraestructura creada"
  value = {
    student_name = var.student_name
    region       = "us-east-1"
    environment  = "LocalStack"
  }
}

output "buckets_s3" {
  description = "Buckets S3 creados"
  value = {
    archivos = aws_s3_bucket.mi_bucket_archivos.bucket
    logs     = aws_s3_bucket.mi_bucket_logs.bucket
  }
}

output "tablas_dynamodb" {
  description = "Tablas DynamoDB creadas"
  value = {
    usuarios = aws_dynamodb_table.mi_tabla_usuarios.name
    posts    = aws_dynamodb_table.mi_tabla_posts.name
  }
}

output "lambda_function" {
  description = "Función Lambda creada"
  value = {
    name = aws_lambda_function.mi_lambda.function_name
    arn  = aws_lambda_function.mi_lambda.arn
  }
}

output "comandos_para_probar" {
  description = "Comandos para probar tu infraestructura"
  value = {
    listar_buckets = "awslocal s3 ls"
    listar_tablas  = "awslocal dynamodb list-tables"
    invocar_lambda = "awslocal lambda invoke --function-name ${aws_lambda_function.mi_lambda.function_name} output.json"
    ver_resultado  = "cat output.json"
  }
}