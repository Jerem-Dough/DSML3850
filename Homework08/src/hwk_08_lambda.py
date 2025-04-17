import json
import boto3
import io
import csv
import re

s3 = boto3.client('s3')

def lambda_handler(event, context):
    print("Lambda triggered!")
    
    try:
        bucket_in = event['Records'][0]['s3']['bucket']['name']
        key = event['Records'][0]['s3']['object']['key']
        print(f"Input bucket: {bucket_in}, Key: {key}")

        # Derive output bucket name
        bucket_out = bucket_in.replace('in', 'out')
        print(f"Output bucket: {bucket_out}")
        
        # Extract date from filename
        filename = key.split('/')[-1]
        date = filename.replace('.csv', '')

        # Check if filename is valid
        if not re.match(r'^\d{8}\.csv$', filename):
            print("Filename pattern did not match. Exiting.")
            return {'statusCode': 200, 'body': json.dumps('Nothing to do!')}

        response = s3.get_object(Bucket=bucket_in, Key=key)
        content = response['Body'].read().decode('utf-8').splitlines()
        reader = csv.DictReader(content)

        total = 0.0
        for row in reader:
            print(f"Row: {row}")
            try:
                total += float(row['amount'])
            except Exception as e:
                print(f"Skipping row due to error: {e}")

        summary_content = f"date,amount\n{date},{total}\n"
        summary_key = f"{date}_summary.csv"
        print(f"Uploading summary to: {summary_key} with total: {total}")

        s3.put_object(
            Bucket=bucket_out,
            Key=summary_key,
            Body=summary_content.encode('utf-8'),
            ContentType='text/csv'
        )

        return {
            'statusCode': 200,
            'body': json.dumps('Daily summary file created successfully!')
        }

    except Exception as e:
        print(f"Error occurred: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error processing CSV file: {str(e)}')
        }
