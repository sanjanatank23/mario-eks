# 🚀 Mario App on AWS EKS with CI/CD

This project demonstrates deploying a **containerized Mario game application** on **Amazon EKS** using **Terraform**, and automating build & deployment using **GitHub Actions CI/CD**.

The goal of this project is to understand **end-to-end Kubernetes deployment** on AWS with **real infrastructure**, not theory.

---

## 📌 What This Project Does

✔ Creates AWS infrastructure using Terraform  
✔ Builds a Docker image for the Mario app  
✔ Pushes the image to Amazon ECR  
✔ Runs the application on EKS using Kubernetes  
✔ Automates everything with a CI/CD pipeline  

---

## 🧱 Architecture Overview
GitHub Push
↓
GitHub Actions (CI/CD)
↓
Build Docker Image
↓
Push Image to Amazon ECR
↓
Update Kubernetes Deployment
↓
EKS Node pulls image
↓
Pod runs Mario App

---

## 🧩 Components Used

### 1️⃣ Infrastructure (Terraform)

- **VPC**
  - Public subnets
  - Internet Gateway
  - Route tables
  - Kubernetes subnet tags

- **EKS Cluster**
  - Kubernetes control plane
  - IAM role for EKS

- **EKS Managed Node Group**
  - EC2 instances (`t3.micro` – free tier safe)
  - Node IAM role
  - Joins EKS automatically

- **IAM**
  - Node role (ECR + EKS access)
  - GitHub Actions OIDC role (secure CI/CD auth)


### 2️⃣ Application

- **Dockerized Mario Game**
- Dockerfile located in:

  app/Dockerfile
- Static HTML-based game

---

### 3️⃣ Container Registry

- **Amazon ECR**
- Stores Docker images
- Images tagged with Git commit SHA

---

### 4️⃣ Kubernetes (Manifests)

Located in `k8s/` directory:

- **Deployment**
- Runs Mario container
- Defines CPU & memory requests
- **Service**
- Type: NodePort
- Exposes application externally

---

### 5️⃣ CI/CD Pipeline (GitHub Actions)
.github/workflows/cicd.yml
Workflow file:

#### Pipeline Steps:
1. Trigger on push to `main`
2. Authenticate to AWS using **OIDC**
3. Build Docker image
4. Scan image using **Trivy**
5. Push image to ECR
6. Update Kubernetes deployment on EKS

✔ No AWS access keys stored  
✔ Secure authentication using IAM + OIDC  

---

## 🔐 Why IAM Roles Are Important

- **Node IAM Role**
  - Allows nodes to:
    - Pull images from ECR
    - Join EKS cluster

- **GitHub Actions IAM Role**
  - Allows CI/CD pipeline to:
    - Push images to ECR
    - Deploy to EKS
  - Uses **OIDC (no secrets needed)**

---

## 🧠 Key Kubernetes Concepts Learned

| Concept | Explanation |
|------|------------|
| NodeGroup | Creates EC2 nodes |
| Node | Worker machine |
| Pod | Runs the container |
| Deployment | Manages Pods |
| Service | Exposes Pods |
| Scheduler | Places Pods on Nodes |

---

## 🌐 How Traffic Reaches the App

Browser
↓
Node Public IP : NodePort
↓
Kubernetes Service
↓
Pod
↓
Mario Game


---

## 🛠 Useful Commands

```bash
# Check nodes
kubectl get nodes

# Check pods
kubectl get pods

# Describe pod
kubectl describe pod <pod-name>

# Access app
http://<node-public-ip>:<node-port>
