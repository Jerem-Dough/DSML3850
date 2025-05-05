FROM public.ecr.aws/lambda/python:3.11

# Copy source files
COPY src/prj_02_lambda.py ${LAMBDA_TASK_ROOT}
COPY src/requirements.txt .

# Install dependencies
RUN pip install -r requirements.txt

# Command
CMD ["prj_02_lambda.lambda_handler"]
