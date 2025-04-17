[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/6Yzf8Ros)
# Overview

The goal of this assignment is to assess your understanding of Lambda function in AWS which is how to implement the serverless computing paradigm. 

# Instructions

You are tasked with writing and deploying a Lambda function in Python that is triggered when an object is uploaded to an S3 bucket. The function should only be triggered by objects with a CSV extension. The uploaded CSV files are named using the format ```yyyymmdd.csv``` and contain daily sales information and are expected to have the following structure:

```
date-time,amount
yyyymmdd hh:mm,999.99
```

You can assume that only one CSV file will be uploaded per day. Upon execution, the function will sum the daily sales and update the ```yyyymmdd_summary.csv``` file with the following structure

```
date,amount
yyyymmdd, 9,999.99
```

## Lambda Function Packaging 

You should use Python version 3.11 as the platform for your Lambda service. To ensure this platform is used, the Lambda service will be built in a Docker container. Start by creating a Docker image using ```public.ecr.aws/lambda/python``` as the base image and having as the target platform the Intel/AMD 64 platform using:

```
docker build --platform linux/amd64 -t hwk_08_lambda .
```

```
docker run --rm hwk_08_lambda bash
```

And then, while leaving that shell running, use the following to download the zip file of the Lambda function build from the container: 

```
docker cp $(docker ps -lq):/hwk_08_lambda.zip .
```

After that you can "kill" the container.

## Terraform

Write the terraform code that creates S3 buckets and a Lambda function using the zip file from the packaging done earlier. 

## Testing 

Upload the [data/20250324.csv](data/20250324.csv) file to the S3 bucket using the following:

```
aws s3 cp data/20250324.csv s3://hwk-08-bucket-in-tm/
```

After a successful run, download the summarized csv file using the following, making sure to change the example to use your bucket's name: 

```
aws s3 cp s3://hwk-08-bucket-out-tm/20250324_summary.csv data/20250324_summary.csv
```

The content of the [data/20250324_summary.csv](data/20250324_summary.csv) should be: 

```
date,amount
20250324,500.0
```

# Grading 

To get full grade on this assignment, you should push the modified [src/hwk_08_lambda.csv](src/hwk_08_lambda.csv) together with [infrastructure/main.tf]([infrastructure/main.tf]). 