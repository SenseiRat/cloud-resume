import sys
import boto3

table_name = 'Cloud-Resume-Visitors'
client = boto3.client('dynamodb')

def send_response(status, msg, trace=''):
    if status is 'Failed':
        response = {
            'Status': status,
            'Message': msg,
            'Response': trace
        }
    else:
        response = {
            'Status': status,
            'Visitors': msg
        }
    
    return response


def lambda_handler(event, context):
    # Get the current number of visitors stored in the database
    try:
        data = client.get_item(
            TableName = table_name,
            Key = {'pkey': {'S': "num_visits"}},
            ProjectionExpression = "visitors"
        )
    except:
        status = 'Failed'
        msg = 'ERROR - Unable to retrieve current visitor count.'
        trace = data
        response = send_response(status, msg, trace)

    # Add a new visitor to the count
    try:
        new_visitors = int(data['Item']['visitors']['N']) + 1
    except:
        status = 'Failed'
        msg = 'ERROR - Unable to increment current visitor count.'
        response = send_response(status, msg)
    
    # Store the new value in the database
    try:
        attempt = client.put_item(
            TableName = table_name,
            Item = {
                'pkey': {'S': 'num_visits'},
                'visitors': {'N':str(new_visitors)}
            }
        )
    except:
        status = 'Failed'
        msg = 'ERROR - Unable to store new visitor count in database.'
        trace = attempt
        response = send_response(status, msg, trace)
    else:
        # Return valid response with current number of visitors
        status = 'Success'
        msg = new_visitors
        response = send_response(status, msg)

    return response