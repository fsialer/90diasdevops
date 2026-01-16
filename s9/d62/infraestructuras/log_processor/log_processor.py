# log_processor.py
import json
import boto3
from datetime import datetime
import gzip
import uuid

def lambda_handler(event, context):
    """
    Procesador de logs: recibe logs → DynamoDB (índice) → S3 (storage)
    """
    print(f"Procesando logs: {json.dumps(event)}")
    
    # Clientes AWS
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
        # Procesar cada entrada de log
        logs = event.get('logs', [])
        if not logs:
            logs = [event]  # Si se envía un log individual
        
        processed_logs = []
        log_batch_id = str(uuid.uuid4())
        
        for log_entry in logs:
            timestamp = int(datetime.now().timestamp() * 1000)  # milliseconds
            log_id = str(uuid.uuid4())
            
            # Extraer información del log
            level = log_entry.get('level', 'INFO').upper()
            message = log_entry.get('message', '')
            service = log_entry.get('service', 'unknown')
            user_id = log_entry.get('user_id', 'anonymous')
            
            # Preparar entrada procesada
            processed_log = {
                'log_id': log_id,
                'timestamp': timestamp,
                'level': level,
                'message': message,
                'service': service,
                'user_id': user_id,
                'batch_id': log_batch_id,
                'processed_at': datetime.now().isoformat()
            }
            
            processed_logs.append(processed_log)
            
            # Indexar en DynamoDB (para búsquedas rápidas)
            dynamodb.put_item(
                TableName='RoxsLogIndex',
                Item={
                    'LogLevel': {'S': level},
                    'Timestamp': {'N': str(timestamp)},
                    'LogId': {'S': log_id},
                    'Message': {'S': message[:100]},  # Truncar mensaje para índice
                    'Service': {'S': service},
                    'UserId': {'S': user_id},
                    'BatchId': {'S': log_batch_id}
                }
            )
        
        # Guardar logs completos en S3 (comprimidos)
        log_date = datetime.now().strftime('%Y/%m/%d')
        log_hour = datetime.now().strftime('%H')
        s3_key = f"logs/{log_date}/{log_hour}/{log_batch_id}.json.gz"
        
        # Comprimir logs
        logs_json = json.dumps(processed_logs, indent=2)
        compressed_logs = gzip.compress(logs_json.encode('utf-8'))
        
        # Subir a S3
        s3_client.put_object(
            Bucket='roxs-logs-storage',
            Key=s3_key,
            Body=compressed_logs,
            ContentType='application/json',
            ContentEncoding='gzip',
            Metadata={
                'log-count': str(len(processed_logs)),
                'batch-id': log_batch_id,
                'processed-at': datetime.now().isoformat()
            }
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': f'Procesados {len(processed_logs)} logs exitosamente',
                'batch_id': log_batch_id,
                'storage_location': f"s3://roxs-logs-storage/{s3_key}",
                'logs_indexed': len(processed_logs)
            })
        }
        
    except Exception as e:
        print(f"Error procesando logs: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }