# image_processor.py
import json
import boto3
import uuid
from datetime import datetime
import base64

def lambda_handler(event, context):
    """
    Procesador de imágenes: S3 → Lambda → DynamoDB
    """
    print(f"Event recibido: {json.dumps(event)}")
    
    # Clientes AWS para LocalStack
    s3_client = boto3.client(
        's3',
        endpoint_url='http://localstack-main:4566',
        aws_access_key_id='test',
        aws_secret_access_key='test'
    )
    
    dynamodb = boto3.client(
        'dynamodb',
        endpoint_url='http://localstack-main:4566',
        aws_access_key_id='test',
        aws_secret_access_key='test'
    )
    
    try:
        # Extraer información del evento
        source_bucket = event.get('bucket', 'roxs-images-original')
        image_key = event.get('key', 'unknown.jpg')
        
        # Generar ID único para la imagen
        image_id = str(uuid.uuid4())
        timestamp = int(datetime.now().timestamp())
        
        print(f"Procesando imagen: {source_bucket}/{image_key}")
        
        # 1. Obtener información del archivo original
        head_response = s3_client.head_object(Bucket=source_bucket, Key=image_key)
        file_size = head_response['ContentLength']
        content_type = head_response.get('ContentType', 'unknown')
        last_modified = head_response['LastModified'].isoformat()
        
        # 2. Descargar imagen original
        get_response = s3_client.get_object(Bucket=source_bucket, Key=image_key)
        image_content = get_response['Body'].read()
        
        # 3. "Procesar" imagen (simulado - en real usarías PIL/Pillow)
        # Para este demo, creamos una versión "procesada" y un "thumbnail"
        processed_content = image_content  # En real: resize, filters, etc.
        thumbnail_content = image_content[:len(image_content)//2]  # Simular thumbnail más pequeño
        
        # 4. Subir imagen procesada
        processed_key = f"processed/{image_id}-{image_key}"
        s3_client.put_object(
            Bucket='roxs-images-processed',
            Key=processed_key,
            Body=processed_content,
            ContentType=content_type,
            Metadata={
                'original-bucket': source_bucket,
                'original-key': image_key,
                'processed-by': 'roxs-image-processor',
                'processed-at': datetime.now().isoformat()
            }
        )
        
        # 5. Subir thumbnail
        thumbnail_key = f"thumbnails/{image_id}-thumb-{image_key}"
        s3_client.put_object(
            Bucket='roxs-images-thumbnails',
            Key=thumbnail_key,
            Body=thumbnail_content,
            ContentType=content_type,
            Metadata={
                'original-bucket': source_bucket,
                'original-key': image_key,
                'thumbnail-for': image_id
            }
        )
        
        # 6. Guardar metadata en DynamoDB
        dynamodb.put_item(
            TableName='RoxsImageMetadata',
            Item={
                'ImageId': {'S': image_id},
                'UploadTimestamp': {'N': str(timestamp)},
                'OriginalBucket': {'S': source_bucket},
                'OriginalKey': {'S': image_key},
                'OriginalSize': {'N': str(file_size)},
                'ContentType': {'S': content_type},
                'ProcessedKey': {'S': processed_key},
                'ThumbnailKey': {'S': thumbnail_key},
                'ProcessedAt': {'S': datetime.now().isoformat()},
                'Status': {'S': 'completed'},
                'ProcessedBy': {'S': 'lambda'},
                'LastModified': {'S': last_modified}
            }
        )
        
        # 7. Respuesta de éxito
        response = {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Imagen procesada exitosamente',
                'image_id': image_id,
                'original': f"{source_bucket}/{image_key}",
                'processed': f"roxs-images-processed/{processed_key}",
                'thumbnail': f"roxs-images-thumbnails/{thumbnail_key}",
                'size_bytes': file_size,
                'processing_time': 'instant'
            })
        }
        
        print(f"Procesamiento exitoso: {image_id}")
        return response
        
    except Exception as e:
        error_msg = f"Error procesando imagen: {str(e)}"
        print(error_msg)
        
        # Guardar error en DynamoDB
        try:
            dynamodb.put_item(
                TableName='RoxsImageMetadata',
                Item={
                    'ImageId': {'S': str(uuid.uuid4())},
                    'UploadTimestamp': {'N': str(int(datetime.now().timestamp()))},
                    'OriginalBucket': {'S': source_bucket},
                    'OriginalKey': {'S': image_key},
                    'Status': {'S': 'error'},
                    'ErrorMessage': {'S': str(e)},
                    'ProcessedAt': {'S': datetime.now().isoformat()}
                }
            )
        except:
            pass  # Si no podemos guardar el error, continuamos
            
        return {
            'statusCode': 500,
            'body': json.dumps({'error': error_msg})
        }