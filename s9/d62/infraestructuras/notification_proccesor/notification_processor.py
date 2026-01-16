# notification_processor.py
import json
import boto3
from datetime import datetime
import uuid

def lambda_handler(event, context):
    """
    Procesador de notificaciones: SQS → Lambda → SNS → DynamoDB
    """
    print(f"Event: {json.dumps(event)}")
    
    # Clientes AWS
    sqs_client = boto3.client(
        'sqs',
        endpoint_url='http://localstack-main:4566',
        aws_access_key_id='test',
        aws_secret_access_key='test'
    )
    
    sns_client = boto3.client(
        'sns',
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
        notification_id = str(uuid.uuid4())
        timestamp = int(datetime.now().timestamp() * 1000)
        
        # Extraer datos del evento
        notification_type = event.get('type', 'general')
        recipient = event.get('recipient', 'admin@roxs.com')
        title = event.get('title', 'Notificación de Sistema')
        message = event.get('message', 'Mensaje de notificación')
        priority = event.get('priority', 'normal')
        
        # Crear mensaje para SNS
        sns_message = {
            'notification_id': notification_id,
            'type': notification_type,
            'title': title,
            'message': message,
            'recipient': recipient,
            'priority': priority,
            'created_at': datetime.now().isoformat()
        }
        
        # Publicar en SNS
        sns_response = sns_client.publish(
            TopicArn='arn:aws:sns:us-east-1:000000000000:roxs-notifications',
            Message=json.dumps(sns_message),
            Subject=f"[{priority.upper()}] {title}",
            MessageAttributes={
                'notification_type': {
                    'DataType': 'String',
                    'StringValue': notification_type
                },
                'priority': {
                    'DataType': 'String',
                    'StringValue': priority
                }
            }
        )
        
        # Guardar en historial (DynamoDB)
        dynamodb.put_item(
            TableName='RoxsNotificationHistory',
            Item={
                'NotificationId': {'S': notification_id},
                'CreatedAt': {'N': str(timestamp)},
                'Type': {'S': notification_type},
                'Recipient': {'S': recipient},
                'Title': {'S': title},
                'Message': {'S': message},
                'Priority': {'S': priority},
                'SNSMessageId': {'S': sns_response.get('MessageId', 'unknown')},
                'Status': {'S': 'sent'},
                'ProcessedAt': {'S': datetime.now().isoformat()}
            }
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Notificación procesada exitosamente',
                'notification_id': notification_id,
                'sns_message_id': sns_response.get('MessageId'),
                'recipient': recipient,
                'type': notification_type
            })
        }
        
    except Exception as e:
        print(f"Error procesando notificación: {str(e)}")
        
        # Guardar error en historial
        try:
            dynamodb.put_item(
                TableName='RoxsNotificationHistory',
                Item={
                    'NotificationId': {'S': str(uuid.uuid4())},
                    'CreatedAt': {'N': str(int(datetime.now().timestamp() * 1000))},
                    'Status': {'S': 'error'},
                    'ErrorMessage': {'S': str(e)},
                    'ProcessedAt': {'S': datetime.now().isoformat()}
                }
            )
        except:
            pass
            
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }