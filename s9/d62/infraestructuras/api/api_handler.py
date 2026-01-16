# api_handler.py
import json
import boto3
from datetime import datetime
import uuid

def lambda_handler(event, context):
    """
    API Handler: maneja todas las rutas de la API
    """
    print(f"API Event: {json.dumps(event)}")
    
    # Clientes AWS
    dynamodb = boto3.client(
        'dynamodb',
        endpoint_url='http://localstack-main:4566',
        aws_access_key_id='test',
        aws_secret_access_key='test'
    )
    
    s3_client = boto3.client(
        's3',
        endpoint_url='http://localstack-main:4566',
        aws_access_key_id='test',
        aws_secret_access_key='test'
    )
    
    try:
        # Extraer información de la request
        http_method = event.get('httpMethod', 'GET')
        path = event.get('path', '/')
        body = event.get('body', '{}')
        
        if body:
            try:
                body_data = json.loads(body)
            except:
                body_data = {}
        else:
            body_data = {}
        
        # Router básico
        if path == '/health':
            return api_response(200, {'status': 'healthy', 'timestamp': datetime.now().isoformat()})
            
        elif path == '/images' and http_method == 'GET':
            # Listar imágenes procesadas
            response = dynamodb.scan(
                TableName='RoxsImageMetadata',
                ProjectionExpression='ImageId,OriginalKey,ProcessedAt,#status',
                ExpressionAttributeNames={'#status': 'Status'}
            )
            
            images = []
            for item in response.get('Items', []):
                images.append({
                    'id': item.get('ImageId', {}).get('S'),
                    'filename': item.get('OriginalKey', {}).get('S'),
                    'processed_at': item.get('ProcessedAt', {}).get('S'),
                    'status': item.get('Status', {}).get('S', 'unknown')
                })
            
            return api_response(200, {
                'images': images,
                'count': len(images)
            })
            
        elif path == '/logs' and http_method == 'GET':
            # Obtener logs recientes
            response = dynamodb.scan(
                TableName='RoxsLogIndex',
                Limit=20
            )
            
            logs = []
            for item in response.get('Items', []):
                logs.append({
                    'level': item.get('LogLevel', {}).get('S'),
                    'timestamp': int(item.get('Timestamp', {}).get('N', '0')),
                    'message': item.get('Message', {}).get('S'),
                    'service': item.get('Service', {}).get('S')
                })
            
            # Ordenar por timestamp descendente
            logs.sort(key=lambda x: x['timestamp'], reverse=True)
            
            return api_response(200, {
                'logs': logs[:10],  # Top 10 más recientes
                'total_scanned': len(logs)
            })
            
        elif path == '/notifications' and http_method == 'POST':
            # Crear nueva notificación (integrar con sistema anterior)
            title = body_data.get('title', 'Nueva notificación')
            message = body_data.get('message', 'Mensaje desde API')
            priority = body_data.get('priority', 'normal')
            
            # Llamar al procesador de notificaciones
            lambda_client = boto3.client(
                'lambda',
                endpoint_url='http://localstack-main:4566',
                aws_access_key_id='test',
                aws_secret_access_key='test'
            )
            
            notification_payload = {
                'type': 'api',
                'title': title,
                'message': message,
                'priority': priority,
                'recipient': 'api-user@roxs.com'
            }
            
            lambda_response = lambda_client.invoke(
                FunctionName='roxs-notification-processor',
                Payload=json.dumps(notification_payload)
            )
            
            result = json.loads(lambda_response['Payload'].read())
            
            return api_response(200, {
                'message': 'Notificación enviada exitosamente',
                'notification_result': result
            })
            
        elif path.startswith('/files') and http_method == 'GET':
            # Listar archivos en S3
            bucket = 'roxs-images-original'
            try:
                response = s3_client.list_objects_v2(Bucket=bucket)
                files = []
                
                for obj in response.get('Contents', []):
                    files.append({
                        'key': obj['Key'],
                        'size': obj['Size'],
                        'last_modified': obj['LastModified'].isoformat(),
                        'url': f"http://localstack-main:4566/{bucket}/{obj['Key']}"
                    })
                
                return api_response(200, {
                    'bucket': bucket,
                    'files': files,
                    'count': len(files)
                })
                
            except Exception as e:
                return api_response(500, {'error': f'Error accessing S3: {str(e)}'})
                
        elif path == '/stats' and http_method == 'GET':
            # Estadísticas generales del sistema
            stats = {}
            
            # Contar imágenes
            try:
                img_response = dynamodb.scan(
                    TableName='RoxsImageMetadata',
                    Select='COUNT'
                )
                stats['total_images'] = img_response['Count']
            except:
                stats['total_images'] = 0
            
            # Contar logs
            try:
                log_response = dynamodb.scan(
                    TableName='RoxsLogIndex',
                    Select='COUNT'
                )
                stats['total_logs'] = log_response['Count']
            except:
                stats['total_logs'] = 0
            
            # Contar notificaciones
            try:
                notif_response = dynamodb.scan(
                    TableName='RoxsNotificationHistory',
                    Select='COUNT'
                )
                stats['total_notifications'] = notif_response['Count']
            except:
                stats['total_notifications'] = 0
            
            # Contar archivos en S3
            try:
                s3_response = s3_client.list_objects_v2(Bucket='roxs-images-original')
                stats['total_files'] = len(s3_response.get('Contents', []))
            except:
                stats['total_files'] = 0
            
            stats['system_uptime'] = 'LocalStack simulation'
            stats['generated_at'] = datetime.now().isoformat()
            
            return api_response(200, stats)
            
        else:
            # Ruta no encontrada
            return api_response(404, {
                'error': 'Endpoint not found',
                'path': path,
                'method': http_method,
                'available_endpoints': [
                    'GET /health',
                    'GET /images',
                    'GET /logs', 
                    'POST /notifications',
                    'GET /files',
                    'GET /stats'
                ]
            })
            
    except Exception as e:
        print(f"Error in API handler: {str(e)}")
        return api_response(500, {'error': str(e)})

def api_response(status_code, body):
    """Helper para formatear respuestas de API"""
    return {
        'statusCode': status_code,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,OPTIONS'
        }
    }