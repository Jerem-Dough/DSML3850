FROM python:3.11-slim

WORKDIR /app

COPY app/ ./app
COPY run.py .
COPY app/config.ini ./app/config.ini
COPY logistic_model.pkl ./app/logistic_model.pkl
COPY scaler.pkl ./app/scaler.pkl

ENV PYTHONPATH=/app

RUN pip install --no-cache-dir -r app/requirements.txt

CMD ["python", "run.py"]
