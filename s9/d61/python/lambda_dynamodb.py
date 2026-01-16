# lambda_dynamodb.py
import json
import boto3
from datetime import datetime
import uuid

def lambda_handler(event, context):
    """
    Función Lambda que interactúa con DynamoDB
    """
    print(f"Event: {json.dumps(event)}")
    
    # Cliente DynamoDB para LocalStack
    dynamodb = boto3.client(
        'dynamodb',
        endpoint_url='http://localstack-main:4566',
        aws_access_key_id='test',
        aws_secret_access_key='test',
        region_name='us-east-1'
    )
    
    # También podemos usar resource (más pythónico)
    dynamodb_resource = boto3.resource(
        'dynamodb',
        endpoint_url='http://localstack-main:4566',
        aws_access_key_id='test',
        aws_secret_access_key='test',
        region_name='us-east-1'
    )
    
    action = event.get('action', 'list')
    table_name = event.get('table', 'RoxsUsers')
    
    try:
        if action == 'create_user':
            # Crear nuevo usuario
            user_data = event['user_data']
            user_id = str(uuid.uuid4())
            
            response = dynamodb.put_item(
                TableName=table_name,
                Item={
                    'UserId': {'S': user_id},
                    'Name': {'S': user_data['name']},
                    'Email': {'S': user_data['email']},
                    'CreatedAt': {'S': datetime.now().isoformat()},
                    'IsActive': {'BOOL': True}
                }
            )
            
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'message': 'Usuario creado exitosamente',
                    'user_id': user_id
                })
            }
            
        elif action == 'get_user':
            # Obtener usuario específico
            user_id = event['user_id']
            
            response = dynamodb.get_item(
                TableName=table_name,
                Key={'UserId': {'S': user_id}}
            )
            
            if 'Item' in response:
                # Simplificar el formato DynamoDB
                user = {}
                for key, value in response['Item'].items():
                    if 'S' in value:
                        user[key] = value['S']
                    elif 'N' in value:
                        user[key] = int(value['N'])
                    elif 'BOOL' in value:
                        user[key] = value['BOOL']
                
                return {
                    'statusCode': 200,
                    'body': json.dumps({
                        'user': user
                    })
                }
            else:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'error': 'Usuario no encontrado'})
                }
                
        elif action == 'list_users':
            # Listar todos los usuarios
            response = dynamodb.scan(TableName=table_name)
            
            users = []
            for item in response.get('Items', []):
                user = {}
                for key, value in item.items():
                    if 'S' in value:
                        user[key] = value['S']
                    elif 'N' in value:
                        user[key] = int(value['N'])
                    elif 'BOOL' in value:
                        user[key] = value['BOOL']
                users.append(user)
            
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'users': users,
                    'count': len(users)
                })
            }
            
        elif action == 'update_user':
            # Actualizar usuario
            user_id = event['user_id']
            updates = event['updates']
            
            # Construir expression dinámicamente
            update_expression = "SET "
            expression_values = {}
            
            for key, value in updates.items():
                update_expression += f"{key} = :{key}, "
                if isinstance(value, str):
                    expression_values[f":{key}"] = {'S': value}
                elif isinstance(value, int):
                    expression_values[f":{key}"] = {'N': str(value)}
                elif isinstance(value, bool):
                    expression_values[f":{key}"] = {'BOOL': value}
            
            update_expression = update_expression.rstrip(', ')
            
            response = dynamodb.update_item(
                TableName=table_name,
                Key={'UserId': {'S': user_id}},
                UpdateExpression=update_expression,
                ExpressionAttributeValues=expression_values,
                ReturnValues='ALL_NEW'
            )
            
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'message': 'Usuario actualizado exitosamente'
                })
            }
            
        else:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': f'Acción no válida: {action}'})
            }
            
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }