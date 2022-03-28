import os
import sys
import json
import gzip
import boto3
import urllib3
import urllib.parse

table_name = os.environ.get('DYNAMODB_TABLE_NAME')
bucket_name = os.environ.get('RESUME_LOG_BUCKET')

s3 = boto3.client('s3')
dynamodb = boto3.client('dynamodb')

def get_dynamodb_item(table_name, ip_address):
    try:
        data = dynamodb.get_item(
            TableName = table_name,
            Key = {'ip_address': {'S': ip_address }}
        )
    except Exception as e:
        print(e)
        print(ip_address + " not previously found in database.")

    return data


def increment_visit_count(table_name, ip_address, visit_data, request_page):
    visit_count = int(visit_data['Item']['visit_count']['N']) + 1

    try:
        data = dynamodb.update_item(
            TableName = table_name,
            Key = {
                'ip_address': {'S': ip_address},
            },
            UpdateExpression = 'SET visit_count = :val1',
            ExpressionAttributeValues = {
                ':val1': {'N': str(visit_count)}
            }
        )
    except Exception as e:
        print(e)
        print("Unable to update DynamoDB table.")

    # Get the list of pages that have already been visited
    try:
        data = dynamodb.get_item(
            TableName = table_name,
            Key = {'ip_address': {'S': ip_address }}
        )
    except Exception as e:
        print(e)
        print(ip_address + " not previously found in database.")

    print(data['Item']['pages_viewed'])

    for page in data['Item']['pages_viewed']['L']:
        if page['S'] == request_page:
            break
        else:
            try:
                data = dynamodb.update_item(
                    TableName = table_name,
                    Key = {
                        'ip_address': {'S': ip_address},
                    },
                    UpdateExpression = 'SET pages_viewed = list_append(pages_viewed, :val1)',
                    ExpressionAttributeValues = {
                        ':val1': {'L': [{'S': request_page}]}
                    }
                )
            except Exception as e:
                print(e)
                print("Unable to update DynamoDB table.")


def add_new_visitor(table_name, ip_address, request_page):
    # Build the API call for the geolocation API
    url = "https://api.ipgeolocation.io/ipgeo?"
    api_key = "apiKey=" + os.environ.get('IPGEO_API_KEY')
    target_ip = "&ip=" + ip_address
    fields = "&fields=geo"
    filters = "&excludes=country_code2,country_code3,district,zipcode,latitude,longitude"

    api_request = url + api_key + target_ip + fields + filters

    http = urllib3.PoolManager()
    location_data = json.loads(http.request('GET', api_request).data)

    country = location_data['country_name']
    state = location_data['state_prov']
    city = location_data['city']

    try:
        data = dynamodb.put_item(
            TableName = table_name,
            Item = {
                'ip_address': {'S': ip_address},
                'visit_count': {'N': '1'},
                'country': {'S': country},
                'state': {'S': state},
                'city': {'S': city},
                'pages_viewed': {'L': [{'S': request_page}]}
            }
        )
    except Exception as e:
        print(e)
        print("Unable to add entry to DynamoDB")
    
    increment_unique_visitors(table_name)


def get_unique_visitors(table_name):
    try:
        data = dynamodb.get_item(
            TableName = table_name,
            Key = {'ip_address': {'S': '0.0.0.0' }}
        )
    except Exception as e:
        print(e)
        print(ip_address + " not previously found in database.")
    
    if 'Item' in data.keys():
        unique_visitors = data['Item']['visit_count']['N']
    else:
        unique_visitors = 0

    return int(unique_visitors)


def increment_unique_visitors(table_name):
    unique_visitors = get_unique_visitors(table_name) + 1

    try:
        data = dynamodb.put_item(
            TableName = table_name,
            Item = {
                'ip_address': {'S': '0.0.0.0'},
                'visit_count': {'N': str(unique_visitors)}
            }
        )
    except Exception as e:
        print(e)
        print("Unable to add entry to DynamoDB")


def lambda_handler(event, context):
    # Parse the entries going into the S3 bucket and store the IP address, how many times that user has visited, and the country
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')

    try:
        response = s3.get_object(Bucket=bucket, Key=key)
    except Exception as e:
        print(e)
        print('Error getting object {} from bucket {}.  Make sure they exist and are in the same region as this function.'.format(key, bucket))
        raise e

    try:
        logfile = gzip.open(response['Body'], 'rt')
    except Exception as e:
        print(e)
        raise e

    for entry in logfile:
        if entry.startswith("#"):
            continue
        else:
            ip_address = entry.split("\t")[4]
            request_page = entry.split("\t")[7]
            visit_data = get_dynamodb_item(table_name, ip_address)

            if 'Item' in visit_data.keys():
                increment_visit_count(table_name, ip_address, visit_data, request_page)
            else:
                add_new_visitor(table_name, ip_address, request_page)

    unique_visitors = get_unique_visitors(table_name)

    return unique_visitors