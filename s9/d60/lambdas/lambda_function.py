import json
import datetime

def lambda_handler(event,context):
    """
    Función lambda basica que recibe un evento y retorna una respuesta
    """
    print(f"Evento recibido: {json.dumps(event)}")
    print(f"Context: {context}")

    # Procesar el evento
    name = event.get('name','Roxs Developer')
    message = event.get('message','Hello from localstack lambda')

    # Crear respuesta
    response = {
        'statusCode': 200,
        'headers':{
            'Content-Type': 'application/json'
        },
        'body': json.dumps({
            'message': f"¡Hola {name}!",
            'input_message': message,
            'timestamp': datetime.datetime.now().isoformat(),
            'function_name': context.function_name if hasattr(context, 'function_name') else 'roxs-function',
            'processed_by': 'LocalStack Lambda'
        })
    }

    print(f"Respuesta: {json.dumps(response)}")
    return response