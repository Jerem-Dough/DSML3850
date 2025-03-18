FROM python:3.11

# Set the working directory inside the container
WORKDIR /app

# Copy application files into the container
COPY app /app

# Install dependencies
RUN pip install --no-cache-dir -r /app/requirements.txt

# Expose port 5000 (Flask default)
EXPOSE 5000

# Define the command to run the app
CMD ["python", "-m", "flask", "run", "--host=0.0.0.0"]
