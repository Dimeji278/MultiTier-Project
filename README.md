# Capstone Project: Deploy a VNet-Based Multi-Tier Architecture

## 👨‍💻 Group 5 – Azure CLI Infrastructure Project

This project demonstrates the deployment of a secure, VNet-based multi-tier architecture on Microsoft Azure using Bash scripts, Azure CLI, and GitHub version control.

---

## 🎯 Objective

- Provision a virtual network (VNet) with three subnets: Web, App, and DB
- Create Linux VMs in each subnet
- Enforce secure tiered access using Network Security Groups (NSGs)
- Verify internal connectivity (Web → App → DB)
- Automate the full deployment using Bash scripts

---

## 🧰 Tools & Technologies

- Azure CLI
- Bash scripting
- SSH
- GitHub
- NSG Rules
- Ubuntu Linux VMs

---

## 🛠️ Project Structure

```
group5-multitier/
├── scripts/
│   ├── init-network-infra.sh
│   ├── configure-nsgs.sh
│   ├── provision-vms.sh
│   └── deploy-all.sh
├── screenshots/
│   ├── ssh-webvm.png
│   ├── ping-web-to-app.png
│   ├── telnet-app-to-db.png
│   └── nsg-rules.png
├── Capstone_Project_Presentation.pptx
├── README.md
```

---

## 🚀 Deployment Steps

### 1. Initialize Network Infrastructure
Creates the VNet and three subnets:
- `WebSubnet`: 10.0.1.0/24
- `AppSubnet`: 10.0.2.0/24
- `DBSubnet`: 10.0.3.0/24

Script:
```bash
bash ./scripts/init-network-infra.sh
```

### 2. Configure NSGs
Creates three NSGs, applies access rules, and associates them with subnets.

Script:
```bash
bash ./scripts/configure-nsgs.sh
```

### 3. Provision Linux VMs
Creates and configures Ubuntu Linux VMs in each subnet.

Script:
```bash
bash ./scripts/provision-vms.sh
```

### 4. Deploy Everything At Once (Optional)
Run the full automation from start to finish.

Script:
```bash
bash ./deploy-all.sh
```

---

## 🔐 NSG Rules Summary

| NSG     | Inbound Allowed From         | Port(s) | Purpose                      |
|---------|------------------------------|---------|------------------------------|
| WebNSG  | Your Public IP               | 22      | SSH                          |
| WebNSG  | `*`                          | 80      | HTTP                         |
| AppNSG  | WebSubnet (`10.0.1.0/24`)    | 22      | SSH from WebVM              |
| AppNSG  | Your Public IP               | 22      | SSH for testing             |
| DBNSG   | AppSubnet (`10.0.2.0/24`)    | 3306    | MySQL access from AppVM     |
| DBNSG   | Your Public IP               | 22      | SSH for testing             |

---

## 🔎 Verification Screenshots

All captured in the `screenshots/` folder:
- ✅ SSH from local to WebVM
- ✅ WebVM ping/curl to AppVM
- ✅ AppVM ping/telnet to DBVM
- ✅ NSG rule outputs

---

## 📊 Presentation

The PowerPoint slide deck `Capstone_Project_Presentation.pptx` contains:
- Project overview
- Architecture breakdown
- Screenshots
- NSG rules
- GitHub link

---

## 🔗 GitHub Repository

> _Replace this with your repo link once uploaded_  

---

## 👏 Contributors

- Oladimeji Alabi (Dimeji)
