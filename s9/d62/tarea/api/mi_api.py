# mi_api.py
import json
import boto3

def lambda_handler(event, context):
    path = event.get('path', '/')
    
    if path == '/health':
        return {
            'statusCode': 200,
            'body': json.dumps({'status': 'ok', 'student': 'Fernando Sialer'})
        }
    elif path == '/stats':
        return {
            'statusCode': 200, 
            'body': json.dumps({
                'images_processed': 'check_dynamodb',
                'logs_generated': 'check_dynamodb',
                'student': 'Fernando Sialer'
            })
        }
    else:
        return {
            'statusCode': 404,
            'body': json.dumps({'error': 'Not found'})
        }