from flask import Flask, render_template, request, jsonify
import os

# Get app name from environment variable or use default
app_name = os.getenv('FLASK_APP', 'chat_app')
app = Flask(app_name)

# Store chat messages in memory (for demonstration)
chat_history = []

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/send_message', methods=['POST'])
def send_message():
    data = request.get_json()
    message = data.get('message', '')
    
    if message:
        # Add user message to history
        chat_history.append({"sender": "user", "message": message})
        
        # Simple response (you can make this more sophisticated)
        response = f"You said: {message}"
        chat_history.append({"sender": "bot", "message": response})
        
        return jsonify({"response": response})
    
    return jsonify({"error": "Empty message"}), 400

@app.route('/get_history')
def get_history():
    return jsonify(chat_history)

if __name__ == '__main__':
    print(f"Starting {app.name} in {os.getenv('ENVIRONMENT', 'development')} mode...")
    app.run(host='0.0.0.0', port=5000, debug=os.getenv('FLASK_DEBUG', '0') == '1')