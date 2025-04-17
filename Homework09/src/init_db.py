import boto3
import random
import string

def generate_hex_key():
    return ''.join(random.choices(string.hexdigits, k=32))

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('hwk_09_keys')

for _ in range(3):
    key = generate_hex_key()
    table.put_item(Item={'key': key})
    print(key)
