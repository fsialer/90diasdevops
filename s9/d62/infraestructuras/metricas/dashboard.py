# dashboard.py
import json
import boto3
from datetime import datetime, timedelta

def lambda_handler(event, context):
    """
    Dashboard de métricas del sistema completo
    """
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
    
    lambda_client = boto3.client(
        'lambda',
        endpoint_url='http://localstack-main:4566',
        aws_access_key_id='test',
        aws_secret_access_key='test'
    )
    
    try:
        dashboard_data = {}
        
        # Métricas de imágenes
        try:
            img_response = dynamodb.scan(TableName='RoxsImageMetadata')
            images = img_response.get('Items', [])
            
            dashboard_data['images'] = {
                'total': len(images),
                'successful': len([img for img in images if img.get('Status', {}).get('S') == 'completed']),
                'failed': len([img for img in images if img.get('Status', {}).get('S') == 'error']),
                'avg_size': sum(int(img.get('OriginalSize', {}).get('N', '0')) for img in images) / max(len(images), 1)
            }
        except:
            dashboard_data['images'] = {'total': 0, 'successful': 0, 'failed': 0, 'avg_size': 0}
        
        # Métricas de logs
        try:
            log_response = dynamodb.scan(TableName='RoxsLogIndex')
            logs = log_response.get('Items', [])
            
            log_levels = {}
            for log in logs:
                level = log.get('LogLevel', {}).get('S', 'UNKNOWN')
                log_levels[level] = log_levels.get(level, 0) + 1
            
            dashboard_data['logs'] = {
                'total': len(logs),
                'by_level': log_levels,
                'recent_errors': len([log for log in logs if log.get('LogLevel', {}).get('S') == 'ERROR'])
            }
        except:
            dashboard_data['logs'] = {'total': 0, 'by_level': {}, 'recent_errors': 0}
        
        # Métricas de notificaciones
        try:
            notif_response = dynamodb.scan(TableName='RoxsNotificationHistory')
            notifications = notif_response.get('Items', [])
            
            priority_count = {}
            for notif in notifications:
                priority = notif.get('Priority', {}).get('S', 'normal')
                priority_count[priority] = priority_count.get(priority, 0) + 1
            
            dashboard_data['notifications'] = {
                'total': len(notifications),
                'by_priority': priority_count,
                'successful': len([n for n in notifications if n.get('Status', {}).get('S') == 'sent'])
            }
        except:
            dashboard_data['notifications'] = {'total': 0, 'by_priority': {}, 'successful': 0}
        
        # Métricas de S3
        try:
            buckets = ['roxs-images-original', 'roxs-images-processed', 'roxs-images-thumbnails', 'roxs-logs-storage']
            s3_metrics = {}
            
            for bucket in buckets:
                try:
                    response = s3_client.list_objects_v2(Bucket=bucket)
                    objects = response.get('Contents', [])
                    total_size = sum(obj['Size'] for obj in objects)
                    s3_metrics[bucket] = {
                        'objects': len(objects),
                        'total_size_bytes': total_size
                    }
                except:
                    s3_metrics[bucket] = {'objects': 0, 'total_size_bytes': 0}
            
            dashboard_data['storage'] = s3_metrics
        except:
            dashboard_data['storage'] = {}
        
        # Métricas de Lambda
        try:
            functions_response = lambda_client.list_functions()
            functions = functions_response.get('Functions', [])
            
            dashboard_data['functions'] = {
                'total': len(functions),
                'names': [f['FunctionName'] for f in functions]
            }
        except:
            dashboard_data['functions'] = {'total': 0, 'names': []}
        
        # Metadata del dashboard
        dashboard_data['metadata'] = {
            'generated_at': datetime.now().isoformat(),
            'system': 'LocalStack',
            'version': '1.0.0'
        }
        
        return {
            'statusCode': 200,
            'body': json.dumps(dashboard_data, indent=2)
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }