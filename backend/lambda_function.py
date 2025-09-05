import json
import requests
import os
import time

def lambda_handler(event, context):
    """
    AWS Lambda function to handle chat requests and integrate with OpenAI API
    """
    
    try:
        # Parse the incoming request
        if 'body' in event:
            body = json.loads(event['body'])
        else:
            body = event
            
        user_message = body.get('message', '')
        
        if not user_message:
            return {
                'statusCode': 400,
                'headers': {
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Headers': 'Content-Type',
                    'Access-Control-Allow-Methods': 'POST, OPTIONS'
                },
                'body': json.dumps({'error': 'No message provided'})
            }
        
        # Call OpenAI API with retry logic for rate limits
        max_retries = 3
        retry_delay = 1
        
        for attempt in range(max_retries):
            try:
                openai_response = requests.post(
                    'https://api.openai.com/v1/chat/completions',
                    headers={
                        'Authorization': f'Bearer {os.environ["OPENAI_API_KEY"]}',
                        'Content-Type': 'application/json',
                        'User-Agent': 'FewtureChatbot/1.0'
                    },
                    json={
                        'model': 'gpt-3.5-turbo',
                        'messages': [
                            {
                                'role': 'system', 
                                'content': 'You are a helpful assistant for Fewture Studios, a cutting-edge technology company. Keep responses brief (1-2 sentences), engaging, and professional. When users ask about projects, work, demos, or want to see something, mention they can see a visual demonstration. Focus on being helpful and directing users to learn more about Fewture\'s innovative work.'
                            },
                            {'role': 'user', 'content': user_message}
                        ],
                        'max_tokens': 100,
                        'temperature': 0.7,
                        'frequency_penalty': 0,
                        'presence_penalty': 0
                    },
                    timeout=15
                )
                
                if openai_response.status_code == 200:
                    ai_reply = openai_response.json()['choices'][0]['message']['content']
                    break
                elif openai_response.status_code == 429:  # Rate limit
                    if attempt < max_retries - 1:
                        # Check if there's a Retry-After header
                        retry_after = openai_response.headers.get('Retry-After')
                        if retry_after:
                            time.sleep(int(retry_after))
                        else:
                            time.sleep(retry_delay * (2 ** attempt))  # Exponential backoff
                        continue
                    else:
                        ai_reply = "Hi! I'm ready to help with questions about Fewture Studios. Try asking me about our projects or demos!"
                        break
                elif openai_response.status_code == 401:
                    ai_reply = "Authentication issue - please contact support."
                    break
                elif openai_response.status_code == 400:
                    response_data = openai_response.json()
                    error_msg = response_data.get('error', {}).get('message', 'Bad request')
                    print(f"OpenAI 400 error: {error_msg}")
                    ai_reply = "Sorry, there was an issue with your request. Please try rephrasing."
                    break
                else:
                    print(f"OpenAI API error {openai_response.status_code}: {openai_response.text}")
                    raise Exception(f"OpenAI API error: {openai_response.status_code}")
                    
            except requests.exceptions.Timeout:
                if attempt < max_retries - 1:
                    time.sleep(retry_delay)
                    continue
                else:
                    ai_reply = "Response timeout. Please try again!"
                    break
        
        # Determine if we should trigger a 3D scene action
        action = None
        trigger_words = ['project', 'work', 'demo', 'show', 'portfolio', 'example', 'see', 'display']
        if any(word in user_message.lower() for word in trigger_words):
            action = 'highlight_model'
        
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'POST, OPTIONS'
            },
            'body': json.dumps({
                'reply': ai_reply,
                'action': action
            })
        }
        
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'POST, OPTIONS'
            },
            'body': json.dumps({
                'reply': 'Sorry, I encountered an error. Please try again.',
                'action': None
            })
        }
