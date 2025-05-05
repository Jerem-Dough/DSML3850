'''
DSML 3850 - Cloud Computing - Spring 2025
Instructor: Thyago Mota
Student(s): Your Name
'''

import boto3
import random
import string
import json

TOTAL_INCIDENTS = 100
REGION = "us-west-1"

dynamodb = boto3.resource('dynamodb', region_name=REGION)
keys_table = dynamodb.Table('prj_02_keys')
incidents_table = dynamodb.Table('prj_02_incidents')

def generate_hex_key():
    return ''.join(random.choices(string.hexdigits.lower(), k=32))

# ✅ Generate and save 3 API keys
print("Generated API Keys:")
for _ in range(3):
    key = generate_hex_key()
    keys_table.put_item(Item={"api_key": key})
    print(key)

# ✅ Load up to 100 incidents from incidents.json
with open("data/incidents.json", "r") as f:
    data = json.load(f)

for i, incident in enumerate(data[:TOTAL_INCIDENTS]):
    if "uid" not in incident:
        incident["uid"] = f"incident_{i}"  # fallback if UID is missing
    incidents_table.put_item(Item=incident)

print(f"\nLoaded {min(len(data), TOTAL_INCIDENTS)} incidents.")
