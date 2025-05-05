'''
DSML 3850 - Cloud Computing - Spring 2025
Instructor: Thyago Mota
Student(s): Your Name
'''

import json
import boto3
from boto3.dynamodb.conditions import Attr

dynamodb = boto3.resource('dynamodb')
keys_table = dynamodb.Table('prj_02_keys')
incidents_table = dynamodb.Table('prj_02_incidents')

def lambda_handler(event, context):
    try:
        params = event.get('queryStringParameters') or {}
        api_key = params.get('api_key')

        if not api_key:
            return {'statusCode': 401, 'body': json.dumps({'message': 'Authentication failed'})}

        # Check if API key exists
        key_response = keys_table.get_item(Key={'api_key': api_key})
        if 'Item' not in key_response:
            return {'statusCode': 401, 'body': json.dumps({'message': 'Authentication failed'})}

        # Start building filter conditions
        filter_expr = None

        if 'year' in params:
            filter_expr = Attr('year').eq(params['year'])

        if 'country' in params:
            expr = Attr('country').contains(params['country'])
            filter_expr = expr if filter_expr is None else filter_expr & expr

        if 'industry' in params:
            expr = Attr('industry').contains(params['industry'])
            filter_expr = expr if filter_expr is None else filter_expr & expr

        if filter_expr:
            response = incidents_table.scan(FilterExpression=filter_expr)
        else:
            response = incidents_table.scan()

        return {
            'statusCode': 200,
            'body': json.dumps({'items': response.get('Items', [])})
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Internal server error', 'error': str(e)})
        }
