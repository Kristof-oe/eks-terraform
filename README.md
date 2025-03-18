 Thesis Project: Django + React + PostgreSQL on AWS

 Overview  
This project demonstrates how to deploy a Django backend with a React frontend and PostgreSQL database using AWS EKS and Terraform. Initially, I planned to use Minikube, but due to various issues, I switched to AWS, which provided a more robust cloud environment for my thesis.  

 Technologies Used  
- **Frontend**: React  
- **Backend**: Django  
- **Database**: PostgreSQL (AWS RDS)  
- **Infrastructure as Code**: Terraform  
- **Container Orchestration**: Kubernetes (EKS)  
- **Storage**: EFS  
- **Load Balancer**: AWS Load Balancer Controller (Helm)  

 Challenges & Solutions  
- **Minikube Limitations** → Switched to AWS EKS  
- **EKS Deployment Delays** → Automated with Terraform  
- **Multi-Zone Database Issue** → Used AWS RDS for Django + EFS for shared storage  
- **Ingress & Security** → Implemented an NLB with proper IAM policies  

 Conclusion  
This project successfully integrates a React-Django application with PostgreSQL on AWS using Kubernetes. The setup is automated with Terraform, and security policies are handled via IAM roles and Helm charts. 
