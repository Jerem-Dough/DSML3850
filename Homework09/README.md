[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/ZzcRMQJB)
# Overview

This assignment assesses your understanding of Lambda functions in the context of a simple API endpoint for authentication. 

# Instructions

## Lambda Function Packaging 

Use what you learned on previous activities to package the Lambda function in [src/hwk_09_lambda.py](src/hwk_09_lambda.py). 

```
docker build --platform linux/amd64 -t hwk_09_lambda .

docker run --rm hwk_09_lambda bash

docker cp $(docker ps -lq):/hwk_09_lambda.zip .
```

After that you can "kill" the container as it already served its purpose. 

## Terraform

### Part 1

Create the dynamodb table named keys to be used for authentication. After the table is created, run [src/init_db.py](src/init_db.py) to randomly create 3 keys. Save them for future use in a credentials file. 

### Part 2

Finish the terraform code that creates an API gateway with a single (root) endpoint served by the Lambda function built previously. 

## Testing & Grading

Use the ```api_gateway_url``` endpoint to test the API, making sure that the API is authenticating the keys using the dynamodb table. 

To submit you work, inform the ```api_gateway_url``` below and push this file. 

```
api_gateway_url: 
```

After you receive your grade, make sure to destroy your cloud computing infrastructure created in both parts 1 and 2. 