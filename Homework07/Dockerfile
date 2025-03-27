FROM python:3.11
WORKDIR /app
ADD src/app /app
COPY requirements.txt /tmp
RUN pip install -r /tmp/requirements.txt
ENV FLASK_APP=/app
EXPOSE 80
CMD ["flask", "run", "-h", "0.0.0.0", "-p", "80", "--debug"]