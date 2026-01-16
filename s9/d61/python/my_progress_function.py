# my_progress_function.py
import json
import boto3

def lambda_handler(event, context):
    dynamodb = boto3.client(
        'dynamodb',
        endpoint_url='http://localstack-main:4566',
        aws_access_key_id='test',
        aws_secret_access_key='test',
        region_name='us-east-1'
    )
    
    student_id = event.get('student_id', 'fernando')
    
    try:
        # Obtener perfil del estudiante
        profile_response = dynamodb.get_item(
            TableName='RoxsStudents',
            Key={'StudentId': {'S': student_id}}
        )
        
        # Obtener progreso del estudiante
        progress_response = dynamodb.query(
            TableName='RoxsProgress',
            KeyConditionExpression='StudentId = :sid',
            ExpressionAttributeValues={':sid': {'S': student_id}}
        )
        
        # Procesar datos
        profile = profile_response.get('Item', {})
        progress_items = progress_response.get('Items', [])
        
        # Calcular estadísticas
        total_days = len(progress_items)
        completed_days = sum(1 for item in progress_items if item.get('Completed', {}).get('BOOL', False))
        avg_difficulty = sum(float(item.get('Difficulty', {}).get('N', '0')) for item in progress_items) / max(total_days, 1)
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'student_id': student_id,
                'name': profile.get('Name', {}).get('S', 'Unknown'),
                'total_days_logged': total_days,
                'completed_days': completed_days,
                'completion_rate': f"{(completed_days/max(total_days,1)*100):.1f}%",
                'average_difficulty': f"{avg_difficulty:.1f}/5",
                'current_day': profile.get('CurrentDay', {}).get('N', '0')
            })
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }