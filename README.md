# CI/CD Deployment on AWS EKS using GitHub Actions, Helm & Terraform

## 📌 Table of Contents

1. [Introduction](#1-introduction)  
2. [Purpose](#2-purpose)  
3. [Scope](#3-scope)  
4. [Benefits of Implementation](#4-benefits-of-implementation)  
5. [Architecture Diagram](#5-architecture-diagram)  
6. [Procedure](#6-procedure)  
    - [Infrastructure Setup with Terraform](#infrastructure-setup-with-terraform)  
    - [GitHub Repository Setup](#github-repository-setup)  
    - [Helm Installation and Configuration](#helm-installation-and-configuration)  
    - [GitHub Actions CI/CD Pipeline](#github-actions-cicd-pipeline)  
7. [CI/CD Workflow Overview](#8-cicd-workflow-overview)  
8. [Adding Secrets in GitHub](#9-adding-secrets-in-github)  
9. [Conclusion](#10-conclusion)  

---

## 1. Introduction

This guide provides a complete walkthrough for setting up an automated CI/CD pipeline that builds, deploys, and monitors a containerized application using:

- **GitHub Actions**
- **Amazon EKS**
- **Helm**
- **Terraform**

All core infrastructure components (VPC, ECR, EKS, Bastion Host) are provisioned using Terraform to ensure consistency, scalability, and security.

---

## 2. Purpose

To streamline and automate deployment into Kubernetes clusters through CI/CD workflows built using GitHub Actions and infrastructure-as-code principles with Terraform.

---

## 3. Scope

- Provisioning Infrastructure (VPC, EKS, ECR, Bastion) using **Terraform**  
- CI/CD Pipeline using **GitHub Actions**  
- Application deployment via **Helm**  
- Observability via **Prometheus** and **Grafana**

---

## 4. Benefits of Implementation

- 🔁 **CI/CD Automation** for both staging and production  
- 🧱 **Infrastructure as Code** using Terraform  
- 🔍 **Real-time Observability** with Prometheus & Grafana  
- 🔐 **Secure & Isolated Architecture** with public/private subnets  

---

## 5. Architecture Diagram

```
Developer --> GitHub (Push to staging/main)
        --> GitHub Actions (CI/CD Workflow)
        --> Docker Image built & pushed to ECR
        --> Helm Deploy to Amazon EKS
        --> Prometheus & Grafana Monitoring
        --> Bastion for Internal Access
```

---

## 6. Procedure

### Infrastructure Setup with Terraform

Provisioned Components:
- VPC with public and private subnets  
- ECR repositories for staging and production  
- EKS Cluster with managed node groups  
- Bastion Host for internal access  

**Terraform modules** are version-controlled and reusable.

---

### GitHub Repository Setup

- Create a repository and push the application & infrastructure code  
- Use two branches:
  - `staging` (for testing)
  - `main` (for production)

**Directory Structure:**
```
.
├── .github/workflows/main.yml
├── Swiggy-Application-code/
├── swiggy-app-helm-chart/
│   ├── values.staging.yaml
│   └── values.production.yaml
└── terraform/
```

---

### Helm Installation and Configuration

- Install Helm locally and in GitHub Actions runner  
- Add required repos:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

- Local Helm chart used for app deployment  
- Environment-specific values files used:
  - `values.staging.yaml`
  - `values.production.yaml`

---

### GitHub Actions CI/CD Pipeline

#### Trigger

```yaml
on:
  push:
    branches:
      - staging
      - main
```

#### Environment Variables

```yaml
env:
  AWS_REGION: us-east-1
  CLUSTER_NAME: DevOps
  RELEASE_NAME: swiggy
```

---

### Job 1: Build & Push Docker Image

- Dynamically set environment variables based on branch  
- Build Docker image from `Swiggy-Application-code`  
- Push image to ECR repository  

---

### Job 2: Deploy via Helm

- Configure AWS credentials  
- Setup `kubectl` and `helm`  
- Update `kubeconfig`  
- Create namespace (if not exists)  
- Deploy using Helm with environment-specific values  

---

### Helm Deploy Command

```bash
helm upgrade --install $RELEASE_NAME ./swiggy-app-helm-chart \
  -f ./swiggy-app-helm-chart/${{ values_file }} \
  --set image.repository="${{ secrets.AWS_ACCOUNT_ID }}.dkr.ecr.$AWS_REGION.amazonaws.com/${{ ecr_repo }}" \
  --set image.tag=${{ image_tag }} \
  --namespace ${{ namespace }} \
  --create-namespace
```

---

### Monitoring Stack (Prometheus & Grafana)

Deployed via Helm:

```bash
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace
```

- Grafana exposed via LoadBalancer  
- Dashboards configured for pod and app metrics  

---

## 8. CI/CD Workflow Overview

1. Code pushed to `staging` or `main`  
2. CI/CD pipeline runs  
3. Docker image built and pushed to ECR  
4. Helm deployment to appropriate namespace  
5. Monitoring handled by Prometheus and Grafana  
6. App and monitoring stack exposed via LoadBalancer  
7. Bastion Host for secure internal access  

---

## 9. Adding Secrets in GitHub

To configure AWS credentials and other sensitive data:

### 🔐 Steps:

1. Go to **Repository Settings > Secrets and Variables > Actions**  
2. Add the following secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_ACCOUNT_ID`

These are used in the workflow for:
- Authenticating with AWS  
- Pushing Docker images to ECR  
- Accessing the EKS cluster via `kubectl`  

---

## 10. Conclusion

This solution delivers a production-grade CI/CD system using modern DevOps tools and practices. With secure and automated deployment workflows, infrastructure management via Terraform, and full observability via Prometheus and Grafana — this setup ensures reliable and scalable application delivery on AWS.

---

### ✅ Best Practices Implemented

- Infrastructure as Code (Terraform)  
- Separate environments for staging & production  
- Secure secret management via GitHub Secrets  
- Least-privilege IAM roles  
- Full observability with Prometheus & Grafana  
- Namespace isolation in Kubernetes  

---

### 🔧 Best Practices ToDo

- Custom Domain Mapping using **Route 53**  
- TLS/HTTPS setup using **cert-manager** and **Let’s Encrypt**  

---
