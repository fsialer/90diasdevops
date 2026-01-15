# file_processor.py
import json
import boto3

def lambda_handler(event, context):
    s3_client = boto3.client(
        's3',
        endpoint_url='http://localstack-main:4566',
        aws_access_key_id='test',
        aws_secret_access_key='test'
    )
    
    source_bucket = event['source_bucket']
    source_key = event['source_key']
    report_bucket = event.get('report_bucket', 'roxs-reports')
    
    try:
        # Descargar archivo
        response = s3_client.get_object(Bucket=source_bucket, Key=source_key)
        content = response['Body'].read().decode('utf-8')
        
        # Procesar contenido
        lines = content.split('\n')
        words = content.split()
        
        # Crear reporte
        report = {
            'file': f"{source_bucket}/{source_key}",
            'processed_at': context.aws_request_id,
            'stats': {
                'total_lines': len(lines),
                'total_words': len(words),
                'total_characters': len(content)
            }
        }
        
        # Guardar reporte
        report_key = f"reports/{source_key}-report.json"
        s3_client.put_object(
            Bucket=report_bucket,
            Key=report_key,
            Body=json.dumps(report, indent=2)
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Archivo procesado exitosamente',
                'report_location': f"{report_bucket}/{report_key}",
                'stats': report['stats']
            })
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }