# Start with the smallest base image containing Python runtime with the lowest vulnerability risk
FROM python:3.11-slim-buster

# Set working directory
WORKDIR /app

# Copy the Python script and requirements file
COPY src/main.py /app/
COPY requirements.txt /app/
# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set entrypoint for the script
ENTRYPOINT ["python", "/app/main.py"]
CMD []