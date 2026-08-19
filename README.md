# Threat Composer

Threat Composer is a containerised web application for creating and managing cyber threat models.

The application enables users to create, edit and visualise cyber threat models through a web interface, providing a structured way to document threats, mitigations, assumptions and security considerations during system design.

This repository contains the application source code, Docker configuration, Terraform infrastructure and GitHub Actions CI/CD pipeline used to deploy the application to AWS ECS Fargate.

---

## Why This Project?

This project was built to gain practical experience with containerisation, Infrastructure as Code (IaC) and automated cloud deployments.

The project progressed from deploying and managing AWS infrastructure with Terraform to implementing an automated CI/CD pipeline with GitHub Actions.

The result is a repeatable deployment process where a push to the `main` branch automatically builds, versions and deploys a new container image to AWS.

---

## Architecture

The diagram below shows the AWS infrastructure and automated CI/CD deployment workflow used by the project.

![Threat Composer AWS and CI/CD Architecture](docs/architecture.png)

The application runs as a Docker container on Amazon ECS using AWS Fargate.

Application traffic flows through an Application Load Balancer to the ECS service. Container images are stored in Amazon ECR, while application logs are sent to Amazon CloudWatch.

Terraform manages the AWS infrastructure, while GitHub Actions handles application deployments.

---

## AWS Infrastructure

The solution includes:

- Amazon ECS Fargate
- Amazon Elastic Container Registry (ECR)
- Application Load Balancer (ALB)
- Amazon CloudWatch Logs
- AWS Identity and Access Management (IAM)
- GitHub Actions OIDC authentication
- Security Groups
- Amazon S3 remote Terraform state

Terraform is used to define and manage the infrastructure as code.

The Terraform configuration includes:

- Modular Terraform architecture
- Remote state management
- Input validation
- IAM roles and policies
- Security group configuration
- ECS service and task definition
- ALB target group health checks
- ECR image repository

---

## Project Structure

```text
.
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions CI/CD pipeline
│
├── app/
│   ├── Dockerfile
│   ├── nginx.conf
│   └── src/                    # Threat Composer source code
│
├── bootstrap/                  # Terraform backend bootstrap
│
├── docs/
│   └── architecture.png        # AWS and CI/CD architecture diagram
│
├── infra/
│   ├── modules/
│   │   └── ecs/
│   ├── alb.tf
│   ├── backend.tf
│   ├── ecr.tf
│   ├── ecs.tf
│   ├── github-oidc.tf
│   ├── iam.tf
│   ├── networking.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── security-groups.tf
│   └── variables.tf
│
├── .dockerignore
├── .gitignore
└── README.md
```

---

## Technologies

- Terraform
- Docker
- GitHub Actions
- AWS ECS Fargate
- Amazon ECR
- Application Load Balancer
- Amazon CloudWatch
- AWS IAM
- GitHub Actions OIDC
- Amazon S3
- Nginx

---

## Infrastructure as Code

Terraform provisions and manages the AWS infrastructure required by the application.

From the `infra` directory:

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

Terraform state is stored remotely in Amazon S3 rather than being committed to the repository.

The ECS service uses a Terraform lifecycle rule to ignore changes to the deployed task definition revision. This allows Terraform to manage the ECS infrastructure while GitHub Actions manages application deployments without the two processes attempting to overwrite each other's changes.

---

## CI/CD Pipeline

Application deployment is automated using GitHub Actions.

The workflow is triggered by a push to the `main` branch.

```text
Push to main
      |
      v
Checkout repository
      |
      v
Authenticate to AWS using OIDC
      |
      v
Login to Amazon ECR
      |
      v
Build Docker image
      |
      v
Tag image with Git commit SHA
      |
      v
Push image to ECR
      |
      v
Retrieve current ECS task definition
      |
      v
Insert new image URI
      |
      v
Register new task definition revision
      |
      v
Update ECS Fargate service
      |
      v
Wait for service stability
      |
      v
Verify /health endpoint
```

### Image Versioning

Docker images are tagged using the Git commit SHA rather than `latest`.

For example:

```text
threat-composer:a1b7944bd47e2574e8c9638536a1f481dd80b329
```

This provides traceability between the source-code commit, Docker image and ECS deployment, making troubleshooting and rollback easier.

---

## Secure AWS Authentication

GitHub Actions authenticates to AWS using OpenID Connect (OIDC).

No long-lived AWS access keys or secret access keys are stored in GitHub.

The workflow requests a temporary OIDC token, and AWS validates the token against the IAM role's trust policy before allowing the workflow to assume the deployment role.

The trust relationship is restricted to this repository and the `main` branch.

The GitHub Actions IAM role follows least-privilege principles and is granted only the permissions required to:

- Authenticate with ECR
- Push container images to the Threat Composer ECR repository
- Read and register ECS task definitions
- Update the Threat Composer ECS service
- Pass the ECS task execution role when required

---

## Health Checks

The application exposes:

```text
/health
```

which returns:

```json
{"status":"ok"}
```

The endpoint is used by the Application Load Balancer to determine whether ECS targets are healthy.

GitHub Actions also performs a post-deployment request to `/health`. The deployment pipeline fails if the expected healthy response is not returned.

This provides two levels of deployment verification:

1. ECS must report the service as stable.
2. The application itself must successfully respond to the health check.

---

## Deployment

### Infrastructure Changes

Infrastructure changes are managed through Terraform:

```bash
cd infra
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

The Terraform execution plan should always be reviewed before applying infrastructure changes.

### Application Changes

Routine application deployments do not require manually building Docker images, pushing images to ECR or updating ECS.

After making an application change:

```bash
git add .
git commit -m "Describe the change"
git push
```

A push to `main` automatically triggers the GitHub Actions deployment pipeline.

---

## CI/CD Verification

The pipeline was tested end-to-end by making a visible change to the Threat Composer application and pushing the change to `main`.

No manual Docker build, ECR push or ECS deployment commands were performed.

GitHub Actions automatically:

1. Built the updated Docker image.
2. Tagged the image using the Git commit SHA.
3. Pushed the image to Amazon ECR.
4. Created a new ECS task definition revision.
5. Updated the ECS Fargate service.
6. Waited for the service to become stable.
7. Verified the `/health` endpoint.

The application change was then confirmed on the running AWS deployment.

---

## Key Features

- Containerised application using Docker
- Application served using Nginx
- Infrastructure managed with Terraform
- Modular Terraform configuration
- Remote Terraform state in Amazon S3
- ECS Fargate container deployment
- Application Load Balancer
- Dedicated `/health` endpoint
- CloudWatch container logging
- ECR image repository
- Immutable SHA-based image versioning
- Automated GitHub Actions CI/CD
- Keyless AWS authentication using OIDC
- Least-privilege IAM permissions
- Automated ECS deployments
- Post-deployment application health verification
- Security Groups controlling network access

---

## Lessons Learned

This project provided practical experience with:

- Containerising and running a web application with Docker
- Building AWS infrastructure using Terraform
- Structuring Terraform using modules
- Managing remote Terraform state
- Deploying workloads using ECS Fargate
- Storing and versioning container images in ECR
- Configuring Application Load Balancer health checks
- Designing IAM trust and permission policies
- Applying least-privilege access
- Authenticating GitHub Actions to AWS using OIDC
- Building CI/CD workflows with GitHub Actions
- Tagging deployments using Git commit SHAs
- Creating new ECS task definition revisions during deployment
- Separating infrastructure ownership from application deployment ownership
- Diagnosing IAM permission failures
- Detecting and managing Terraform drift
- Performing automated post-deployment health checks

---

## Future Improvements

Potential future enhancements include:

- HTTPS using AWS Certificate Manager (ACM)
- Route 53 custom domain
- ECS Auto Scaling
- CloudWatch dashboards and alarms
