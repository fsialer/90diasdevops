# lambda_with_env.py
import json
import os

def lambda_handler(event, context):
    # Leer variables de entorno
    app_name = os.environ.get('APP_NAME', 'DefaultApp')
    debug_mode = os.environ.get('DEBUG', 'false').lower() == 'true'
    api_url = os.environ.get('API_URL', 'http://localhost:3000')
    
    if debug_mode:
        print(f"Debug mode habilitado para {app_name}")
        print(f"API URL: {api_url}")
    
    return {
        'statusCode': 200,
        'body': json.dumps({
            'app_name': app_name,
            'debug_enabled': debug_mode,
            'api_url': api_url,
            'environment_vars': dict(os.environ)
        })
    }