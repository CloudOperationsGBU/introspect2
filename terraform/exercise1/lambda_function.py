import json
import os

print('Loading function')
print(f"Name of the author: {os.environ.get('name')}")


def awsum(event, context):
    print("Received event: " + json.dumps(event, indent=2))

    try:
        http_method = event['httpMethod']
        body = json.loads(event['body']) if event['body'] else {}
    except KeyError as e:
        print(f"Missing key in event: {e}")
        return {
            'statusCode': 400,
            'body': json.dumps({'message': 'Bad Request'})
        }
    
    if http_method == 'POST':
        response_message = f"POST request received. Body: {body}. \nSum = {int(body.get('key1')) + int(body.get('key2'))}"
    else:
        response_message = f"HTTP method {http_method} not supported."
    
    response = {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json'
        },
        'body': json.dumps({
            'message': response_message
        })
    }

    return response