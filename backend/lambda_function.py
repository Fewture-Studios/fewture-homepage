import json
import requests
import os
import time

def lambda_handler(event, context):
    """
    AWS Lambda function to handle chat requests and integrate with OpenAI API
    Supports enhanced action-driven integration with site UI
    """
    
    try:
        # Handle CORS preflight
        if event.get('httpMethod') == 'OPTIONS':
            return {
                'statusCode': 200,
                'headers': {
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Headers': 'Content-Type',
                    'Access-Control-Allow-Methods': 'POST, OPTIONS'
                },
                'body': ''
            }
        
        # Parse enhanced request body with user context
        user_message = ''
        user_context = {}
        user_info = {}
        
        if 'requestContext' in event and 'elb' in event['requestContext']:
            # ALB event format
            if event.get('httpMethod') != 'POST':
                return {
                    'statusCode': 405,
                    'headers': {
                        'Access-Control-Allow-Origin': '*',
                        'Access-Control-Allow-Headers': 'Content-Type',
                        'Access-Control-Allow-Methods': 'POST, OPTIONS'
                    },
                    'body': json.dumps({'error': 'Method not allowed'})
                }
            
            body_str = event.get('body', '')
            if event.get('isBase64Encoded', False):
                import base64
                body_str = base64.b64decode(body_str).decode('utf-8')
            
            if body_str:
                try:
                    body = json.loads(body_str)
                    user_message = body.get('message', '')
                    user_context = body.get('context', {})
                    user_info = body.get('user', {})
                except json.JSONDecodeError:
                    user_message = ''
            
        elif 'body' in event:
            # API Gateway event format
            try:
                body = json.loads(event['body']) if event['body'] else {}
                user_message = body.get('message', '')
                user_context = body.get('context', {})
                user_info = body.get('user', {})
            except json.JSONDecodeError:
                user_message = ''
        else:
            # Direct invocation
            user_message = event.get('message', '')
            user_context = event.get('context', {})
            user_info = event.get('user', {})
        
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
                                'content': """You are the Fewture Assistant, representing Fewture which combines a Studio, a Fund, and Live IP like the Internet Racing League (IRL).

CORE IDENTITY:
- Fewture Studios: Co-founder engine for creators (Kai Henry CEO, Josh Stein President/COO, Brandon Dalton Chief Attention Officer)
- Fewture Fund: $50M target, 75 investments, $500k-$1.5M checks, Pre-seed to Seed focus
- IRL: Internet Racing League - kart racing with creators, regional format, pilot Aug 2025
- MAL: Purple-themed project (limited details available)

CURRENT SITE CAPABILITIES:
- 5 theme modes: Default, IRL (Dark), Fund (Green), Willie (Red), MAL (Purple)
- Video integration: Full-screen players for IRL, Fund, Willie projects with custom thumbnails
- Navigation: Header nav (Home, About, Team, Projects dropdown, Partners), Footer nav (Terms, Privacy, Careers, Contact)
- Interactive 3D scene: Three.js with particle systems, GLTF models, dynamic camera controls
- Page content system: Dynamic overlays for informational pages
- Theme cycling: Click status button to cycle through all themes
- Responsive design: Mobile-optimized with dynamic positioning

TECHNICAL FUNCTIONS AVAILABLE:
- Theme switching and cycling
- Video content display (IRL, Fund, Willie)
- Page content display (Terms, Privacy, Careers, Contact, About, Team, Partners)
- 3D scene interactions and animations
- Overlay management and navigation

RESPONSE STYLE:
- Warm, clear, professional with short paragraphs
- Always offer 2-3 next steps
- Text-only responses (no images/videos)
- End with suggested actions

LIMITATIONS:
- Single page application (no server-side routing)
- Session-based only (no persistent user data)
- Chat history resets on page refresh
- Requires WebGL support for 3D features

ESCALATION:
- Kai Henry (CEO): Strategic decisions, investor relations
- Josh Stein (President/COO): Operations, media, business
- Brandon Dalton (Chief Attention Officer): Creative projects, IP, talent

Keep responses focused and actionable based on actual site capabilities.

CONTEXT:
User: {user_info.get('name', 'visitor')} | Section: {user_context.get('section', 'home')} | Mode: {user_context.get('mode', 'light')}

STYLE: Brief, direct responses. Suggest 1-2 specific actions. Use site features actively.""".format(user_info=user_info, user_context=user_context)
                            },
                            {'role': 'user', 'content': user_message}
                        ],
                        'max_tokens': 60,
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
        
        # Generate enhanced actions based on message content and context
        actions = generate_actions(user_message, ai_reply, user_context, user_info)
        
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Methods': 'POST, OPTIONS'
            },
            'body': json.dumps({
                'reply': ai_reply,
                'actions': actions,
                'meta': {
                    'safe_text_only': True,
                    'confidence': 0.8
                }
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
                'actions': [],
                'meta': {
                    'safe_text_only': True,
                    'confidence': 0.0
                }
            })
        }

def generate_actions(user_message, ai_reply, user_context, user_info):
    """Generate contextual actions based on user message and AI response"""
    actions = []
    message_lower = user_message.lower()
    reply_lower = ai_reply.lower()
    
    # Theme/Mode switching actions
    if any(word in message_lower for word in ['irl', 'racing', 'league', 'dark']):
        if user_context.get('mode') != 'dark':
            actions.append({'type': 'mode', 'value': 'dark'})
    elif any(word in message_lower for word in ['fund', 'investment', 'capital']):
        if user_context.get('mode') != 'green':
            actions.append({'type': 'mode', 'value': 'green'})
    elif any(word in message_lower for word in ['willie', 'mallory']):
        if user_context.get('mode') != 'red':
            actions.append({'type': 'mode', 'value': 'red'})
    elif any(word in message_lower for word in ['mal', 'threading tomorrow', 'albania', 'fashion']):
        if user_context.get('mode') != 'purple':
            actions.append({'type': 'mode', 'value': 'purple'})
    elif any(word in message_lower for word in ['studios', 'fewture', 'default']):
        if user_context.get('mode') != 'light':
            actions.append({'type': 'mode', 'value': 'light'})
    
    # Video actions
    if any(word in message_lower for word in ['irl', 'teaser', 'racing']):
        actions.append({'type': 'open_video', 'value': 'irl'})
    elif any(word in message_lower for word in ['fund', 'investment']):
        actions.append({'type': 'open_video', 'value': 'fund'})
    elif any(word in message_lower for word in ['willie', 'mallory', 'steamboat', 'horror', 'unreal engine']):
        actions.append({'type': 'open_video', 'value': 'willie'})
    elif any(word in message_lower for word in ['mal', 'threading tomorrow', 'albania']):
        actions.append({'type': 'open_page', 'value': 'mal'})
    
    # Page content actions
    if any(word in message_lower for word in ['team', 'people', 'who']):
        actions.append({'type': 'open_page', 'value': 'team'})
    elif any(word in message_lower for word in ['about', 'company', 'story']):
        actions.append({'type': 'open_page', 'value': 'about'})
    
    # Camera actions for visual elements
    if any(word in message_lower for word in ['project', 'work', 'demo', 'show', 'portfolio', 'example', 'see', 'display']):
        actions.append({'type': 'camera', 'value': 'highlight_model'})
    
    # Suggestion actions based on AI response
    if any(phrase in reply_lower for phrase in ['want', 'choose', 'option']):
        if 'fund' in reply_lower and 'studios' in reply_lower:
            actions.append({
                'type': 'suggest', 
                'value': ['60-second overview', 'Fund details', 'Studios info', 'Talk to team']
            })
        elif 'overview' in reply_lower:
            actions.append({
                'type': 'suggest',
                'value': ['Quick overview', 'Deep dive', 'Connect with team']
            })
    
    # Memory actions for personalization
    if user_info.get('name') and not user_context.get('remembered'):
        actions.append({
            'type': 'memory',
            'value': {
                'name': user_info.get('name'),
                'role': user_info.get('role', 'visitor'),
                'last_topic': extract_topic(user_message),
                'timestamp': int(time.time())
            }
        })
    
    return actions

def extract_topic(message):
    """Extract main topic from user message"""
    message_lower = message.lower()
    if any(word in message_lower for word in ['fund', 'investment', 'capital']):
        return 'fund'
    elif any(word in message_lower for word in ['irl', 'racing', 'league']):
        return 'irl'
    elif any(word in message_lower for word in ['studios', 'company', 'team']):
        return 'studios'
    elif any(word in message_lower for word in ['willie', 'mallory']):
        return 'willie'
    elif any(word in message_lower for word in ['mal', 'threading tomorrow', 'albania']):
        return 'mal'
    else:
        return 'general'
