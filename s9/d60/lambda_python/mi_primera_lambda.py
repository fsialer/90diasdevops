# mi_primera_lambda.py
import json

def lambda_handler(event, context):
    nombre = event.get('nombre', 'Estudiante Roxs')
    return {
        'statusCode': 200,
        'body': json.dumps({
            'mensaje': f'¡Hola {nombre}! Bienvenido a Lambda local',
            'evento_recibido': event
        })
    }