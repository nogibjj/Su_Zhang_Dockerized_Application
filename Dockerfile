# Use Python 3.9 slim image as base
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Set environment variables
ENV FLASK_APP="chat_app"
ENV ENVIRONMENT=production
ENV FLASK_DEBUG=0

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the templates directory
COPY templates/ templates/

# Copy application code
COPY app.py .

# Expose port 5000
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]