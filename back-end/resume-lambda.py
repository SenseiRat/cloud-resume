import os
import sys
import boto3
import urllib.parse

table_name = os.environ.get('DYNAMODB_TABLE_NAME')
bucket_name = os.environ.get('RESUME_LOG_BUCKET'

s3 = boto3.client('s3')
dynamodb = boto3.client('dynamodb')

def lambda_handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))
    
    # Parse the entries going into the S3 bucket and store the IP address, how many times that user has visited, and the country
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')

    try:
        response = s3.get_object(Bucket=bucket, Key=key)
        print(response)
    except Exception as e:
        print(e)
        print('Error getting object {} from bucket {}.  Make sure they exist and are in the same region as this function.'.format(key, bucket))
        raise e

    # Get IP address from logs

    # Increment number of times a user has visited

    # Use geolocation to identify where the request originated from

    # Return the total number of users

    # Report data to CloudWatch Logs


    #try:
    #    data = client.get_item(
    #        TableName = table_name,
    #        Key = {'pkey': {'S': "num_visits"}},
    #        ProjectionExpression = "visitors"
    #    )
    
    # Store the new value in the database
    #try:
    #    attempt = client.put_item(
    #        TableName = table_name,
    #        Item = {
    #            'pkey': {'S': 'num_visits'},
    #            'visitors': {'N':str(new_visitors)}
    #        }
    #    )