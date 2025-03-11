FROM python:3.11
WORKDIR /app
ADD src/app /app
ADD templates /app/templates
ADD static /app/static
ADD db.ini /app
COPY requirements.txt /tmp
RUN pip install -r /tmp/requirements.txt
ENV FLASK_APP=/app
EXPOSE 5000
CMD ["flask", "run", "-h", "0.0.0.0", "--debug"]