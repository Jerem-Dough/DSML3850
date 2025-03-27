## **DSML 3850**

This course explores cloud computing concepts, including virtualization, networking, security, serverless computing, and multi-tier application architectures. The projects in this repository involve hands-on experience with cloud infrastructure, automation, and deployment using tools such as Terraform and AWS.

## **Projects**

This repository contains various cloud computing projects completed for DSML3850, focusing on infrastructure provisioning, automation, and cloud-native application deployment. Below is an overview of the implemented projects:

- **Provisioning and Mounting EBS Volumes on AWS (Homework05):**  
Implemented an automated Terraform configuration to provision an AWS Elastic Block Store (EBS) volume and attach it to an EC2 instance. The *setup.sh* script formats the volume, mounts it to the instance, and ensures persistence across reboots.

- **Flask Application Deployment on AWS EC2 (Activity09):**  
Implemented an automated deployment script for provisioning an AWS EC2 instance and setting up a Flask web application. The script installs dependencies, configures system services, and ensures the application starts on boot using systemd.

- **Provisioning and Mounting EFS Volumes on AWS (Homework06):**  
Implemented an automated Terraform configuration to provision an AWS Elastic File System (EFS) and mount it to multiple EC2 instances. The project explores file-system storage virtualization and demonstrates how to configure persistent, scalable cloud storage.

- **Group Web Application Deployment on AWS (Activity13):**  
Designed and deployed a 3-tier AWS cloud architecture with class, integrating a PostgreSQL database, Flask web application, and Docker containerization. The project focuses on infrastructure automation, containerized deployment, and cloud security best practices.

- **Solo Web Application Deployment on AWS (Project1):**  
Deployed a Flask web app in Docker containers using AWS ECS, Terraform, and S3 for secure file storage. Built and pushed Docker images to ECR. Automated infrastructure provisioning, load balancing, and deployment. Built all infrastructure and config files from the ground up.

- **Path-Based Load Balancing on AWS ECS (Homework07):**  
Built a path-based load-balancer using Terraform, ECS, and ALB. Deployed two ECS services with distinct target groups and routed traffic based on URL paths (/a and /b). Docker images were pushed to ECR, and Terraform automated all infrastructure setups.

- **More Projects to Come:**
Last update - 3/27/2025
  
Each project demonstrates core cloud computing concepts, focusing on infrastructure as code, cloud automation, and scalable application deployment.
