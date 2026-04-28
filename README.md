# Omnipotent-Suite ☁️

[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/Omnipotent-Suite)](https://www.powershellgallery.com/packages/Omnipotent-Suite)
[![Azure DevOps](https://img.shields.io/azure-devops/build/omnipotent/1/1)](https://dev.azure.com/omnipotent)
[![AWS](https://img.shields.io/badge/AWS-Terraform-orange)](https://aws.amazon.com)
[![License](https://img.shields.io/github/license/StoreLunchFlow/Omnipotent-Suite)](LICENSE)

> **One PowerShell suite to rule all clouds** – orchestrate VMs, containers, serverless, and hybrid infrastructure.

## ✨ Features
- 🔄 **Cross-cloud orchestration** (Azure, AWS, GCP via PowerShell cmdlets)
- 🧩 **Declarative infrastructure** (Wrapper for Terraform)
- 📦 **Container management** (Docker, AKS, EKS orchestration scripts)
- 🔐 **Secrets rotation** (Key Vault / Parameter Store integration)
- 📊 **Real-time telemetry** (Integration with Prometheus/Grafana exporters)
- ⚡ **High-frequency job scheduling** (Task automation across clouds)

## 📦 Installation
```powershell
Install-Module -Name Omnipotent-Suite -Scope CurrentUser
```

## 🚀 Quick Start
```powershell
# Connect to AWS
Connect-OmnipotentCloud -Provider AWS -Region us-east-1

# Deploy a VM
New-OmnipotentVM -Name prod-web -ImageId ami-12345 -InstanceType t2.micro

# Or, run a cross-cloud task
Invoke-OmnipotentTask -ScriptBlock { Get-Date } -Clouds @("Azure", "AWS")
```

## 📖 [Full documentation](https://omnipotent.dev)

## 🤝 Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md)

## 📄 License
MIT © StoreLunchFlow
