import json
import boto3
from datetime import datetime

def lambda_handler(event, context):
    """
    Funcion que procesa eventos de S3
    """

    print(f"S3 Event: {json.dumps(event)}")

    # Configurar cliene S3 para LocalStack
    s3_client = boto3.client(
        's3',
        endpoint_url='http://localhost:4566',
        aws_access_key_id='test',
        aws_secret_access_key='test',
        region_name='us-east-1'
    )

    # Procesar información del evento
    bucket_name = event.get('bucket', 'roxs-bucket')
    object_key = event.get('key', 'unknown')

    try:
        # Intentar obtener informacion del archivo

        response = s3_client.head_object(Bucket=bucket_name,Key=object_key)
        file_size = response.get('ContentLength',0)
        last_modifies = response.get('LastModified',datetime.now())

        # Crear archivo de procesamiento
        process_info = {
            'processed_file':object_key,
            'file_size_bytes':file_size,
            'last_modified': str(last_modified),
            'procesed_at': datetime.now().isoformat(),
            "status": 'processed'
        }

        # Guardar información de procesamiento
        process_key = f"processed/{object_key}.json"
        s3_client.put_object(
            Bucket=bucket_name,
            Key=process_key,
            Body=json.dumps(process_info, indent=2),
            ContentType='application/json'
        )

        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': f'Archivo {object_key} procesado exitosamente',
                'file_size': file_size,
                'process_info_saved_to': process_key
            })
        }
    except Exception as e:
         print(f"Error procesando archivo: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': f'Error procesando {object_key}: {str(e)}'
            })
        }