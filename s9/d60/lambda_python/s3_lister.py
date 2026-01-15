# s3_lister.py
import json
import boto3

def lambda_handler(event, context):
    s3_client = boto3.client(
        's3',
        endpoint_url='http://localstack-main:4566',
        aws_access_key_id='test',
        aws_secret_access_key='test'
    )
    
    bucket = event.get('bucket', 'roxs-bucket')
    
    try:
        response = s3_client.list_objects_v2(Bucket=bucket)
        files = []
        
        if 'Contents' in response:
            files = [obj['Key'] for obj in response['Contents']]
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'bucket': bucket,
                'total_files': len(files),
                'files': files
            })
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }