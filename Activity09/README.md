# Overview

In this activity you are asked to create an EC2 instance and to run a simple web app using flask. 

# Instructions 

Different than Activity 08 discussed in class, this time you will not break down the terraform code into modules, so you can compare both design choices. Make any necessary modifications to variables in [infrastructure/variables.tf](infrastructure/variables.tf). Create and run [infrastructure/main.tf](infrastructure/main.tf). 

[infrastructure/setup.sh](infrastructure/setup.sh) is a "user data" script that automatically creates a simple "hello world" flask app and configures the web app to run as a service. 

When you are ready, use ```terraform init``` to initialize terraform's working directory. Then, use ```terraform validate``` to check any syntax errors before you build your configuration using ```terraform apply -auto-approve```.  The script should download the SSH private key (file ```key-test-us-west-1-web-ssh.pem```) and display the EC2 instance's public IP address. Use to try accesing your flask app from a browser using: 

```
http://<YOUR-IP-ADDRESS>:5001
```

Destroy your configuration using ```terraform destroy -auto-approve```. 
