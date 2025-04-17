import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('hwk_09_keys')

def lambda_handler(event, context):
    try:
        if 'queryStringParameters' in event and 'key' in event['queryStringParameters']: 
            key = event['queryStringParameters']['key']
            response = table.get_item(Key={'key': key})
            if 'Item' in response: 
                return {
                    'statusCode': 200,
                    'body': json.dumps({'message': 'Authentication successful'})
                }
            else:
                return {
                    'statusCode': 401,
                    'body': json.dumps({'message': 'Authentication failed'})
                }
        else: 
            return {
                'statusCode': 401,
                'body': json.dumps({'message': 'Authentication failed'})
            }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Internal server error', 'error': str(e)})
        }