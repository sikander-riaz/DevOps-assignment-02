# 🚀 Infrastructure Automation Setup

This repository sets up infrastructure using **Terraform**, configures it using **Ansible**, and deploys services with **Docker Compose**.

---

## 🧰 Tech Stack

- **Terraform** – Provisioning infrastructure  
- **Ansible** – Configuration management  
- **Docker Compose** – Container orchestration  
- **Shell Script** – For Ansible installation

---

## 📁 Project Structure

```bash
.
├── ansible.sh             # Shell script to install Ansible
├── docker-install.yml     # Ansible playbook to install Docker & run docker-compose
├── main.tf                # Terraform configuration file
└── README.md              # This file


## 1. Clone the Repository

```bash
git clone https://github.com/your-username/your-repo.git
cd your-repo


## 2. Install Ansible

```bash
bash ansible.sh


## 3. Provision Infrastructure with Terraform

```bash
terraform init
terraform apply

4. Configure Docker & Run Docker Compose with Ansible

```bash
ansible-playbook docker-install.yml
