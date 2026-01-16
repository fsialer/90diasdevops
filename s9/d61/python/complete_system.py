# complete_system.py
import json
import boto3
from datetime import datetime
import uuid

def lambda_handler(event, context):
    """
    Sistema completo: Procesa archivos de S3 y guarda metadata en DynamoDB
    """
    
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
    
    action = event.get('action', 'process_file')
    
    try:
        if action == 'process_file':
            bucket = event['bucket']
            key = event['key']
            
            # 1. Obtener información del archivo S3
            file_info = s3_client.head_object(Bucket=bucket, Key=key)
            file_size = file_info['ContentLength']
            last_modified = file_info['LastModified'].isoformat()
            
            # 2. Descargar y procesar contenido
            response = s3_client.get_object(Bucket=bucket, Key=key)
            content = response['Body'].read().decode('utf-8')
            
            # Análisis básico del contenido
            lines = content.split('\n')
            words = content.split()
            chars = len(content)
            
            # 3. Guardar metadata en DynamoDB
            file_id = str(uuid.uuid4())
            
            dynamodb.put_item(
                TableName='RoxsFileMetadata',
                Item={
                    'FileId': {'S': file_id},
                    'Bucket': {'S': bucket},
                    'Key': {'S': key},
                    'SizeBytes': {'N': str(file_size)},
                    'LastModified': {'S': last_modified},
                    'ProcessedAt': {'S': datetime.now().isoformat()},
                    'LineCount': {'N': str(len(lines))},
                    'WordCount': {'N': str(len(words))},
                    'CharCount': {'N': str(chars)},
                    'FileType': {'S': key.split('.')[-1] if '.' in key else 'unknown'}
                }
            )
            
            # 4. Crear archivo de reporte en S3
            report = {
                'file_id': file_id,
                'original_file': f"{bucket}/{key}",
                'analysis': {
                    'lines': len(lines),
                    'words': len(words),
                    'characters': chars,
                    'size_bytes': file_size
                },
                'processed_at': datetime.now().isoformat()
            }
            
            report_key = f"reports/{key}-analysis.json"
            s3_client.put_object(
                Bucket=bucket,
                Key=report_key,
                Body=json.dumps(report, indent=2),
                ContentType='application/json'
            )
            
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'message': 'Archivo procesado exitosamente',
                    'file_id': file_id,
                    'report_location': f"{bucket}/{report_key}",
                    'analysis': report['analysis']
                })
            }
            
        elif action == 'get_file_stats':
            # Obtener estadísticas de todos los archivos procesados
            response = dynamodb.scan(TableName='RoxsFileMetadata')
            
            items = response.get('Items', [])
            total_files = len(items)
            total_size = sum(int(item.get('SizeBytes', {}).get('N', '0')) for item in items)
            
            file_types = {}
            for item in items:
                file_type = item.get('FileType', {}).get('S', 'unknown')
                file_types[file_type] = file_types.get(file_type, 0) + 1
            
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'total_files_processed': total_files,
                    'total_size_bytes': total_size,
                    'file_types': file_types,
                    'files': [
                        {
                            'file_id': item.get('FileId', {}).get('S'),
                            'path': f"{item.get('Bucket', {}).get('S')}/{item.get('Key', {}).get('S')}",
                            'size': int(item.get('SizeBytes', {}).get('N', '0')),
                            'processed_at': item.get('ProcessedAt', {}).get('S')
                        }
                        for item in items
                    ]
                })
            }
            
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }