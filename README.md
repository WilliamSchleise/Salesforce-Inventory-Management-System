<div align="center">

<img src="https://img.shields.io/badge/Salesforce-00A1E0?style=for-the-badge&logo=salesforce&logoColor=white" />
<img src="https://img.shields.io/badge/Apex-032D60?style=for-the-badge&logo=salesforce&logoColor=white" />
<img src="https://img.shields.io/badge/SOQL-00A1E0?style=for-the-badge&logo=salesforce&logoColor=white" />
<img src="https://img.shields.io/badge/Salesforce_Flow-0176D3?style=for-the-badge&logo=salesforce&logoColor=white" />

<br/><br/>

# 📦 Inventory Management System

### A full-featured stock control platform built on Salesforce — automating every step from movement tracking to order approval.

</div>

---

## 🗂️ Overview

The **Inventory Management System** is an enterprise-grade application developed on the Salesforce platform to automate and streamline stock control operations. It handles the complete lifecycle of inventory — from real-time stock movement tracking to structured order approval workflows — while ensuring data quality through built-in validations and smart API integrations.

---

## ✨ Features

| Feature | Description |
|---|---|
| 🔄 **Automated Stock Movements** | Tracks and processes stock entries and exits automatically, reducing manual effort |
| ✅ **Order Approval Workflows** | Structured approval processes built with Salesforce Flow to ensure compliance |
| 📋 **Task Lifecycle Management** | Full control over task states — from opening to completion |
| 🪪 **CPF & CNPJ Validation** | Built-in logic to validate Brazilian tax identifiers and guarantee data integrity |
| 🗺️ **Address API Integration** | Automatic address population via external CEP lookup API, minimizing input errors |

---

## 🏗️ Tech Stack

- **Language:** Apex (back-end logic & triggers)
- **Query Language:** SOQL (data retrieval & filtering)
- **Automation:** Salesforce Flow (approval processes & workflows)
- **Platform:** Salesforce CRM
- **External Integration:** ViaCEP / Address Lookup REST API

---

## 🔧 Key Modules

### 📦 Stock Movement
Automates the registration of inbound and outbound stock. Every movement is logged and linked to products, ensuring a reliable audit trail.

### 🔁 Order Approval Process
Multi-step approval workflows built with Salesforce Flow. Orders are routed to the appropriate approvers based on configurable business rules.

### ✅ Task Management
Tasks are created, assigned, and tracked through their full lifecycle. Supports status transitions from **Open → In Progress → Completed**.

### 🇧🇷 CPF / CNPJ Validation
Custom Apex logic validates individual (CPF) and corporate (CNPJ) Brazilian tax numbers at record creation and update, preventing invalid data from entering the system.

### 📍 Address Lookup Integration
Integrates with an external REST API (e.g., ViaCEP) to automatically fill in address fields based on the ZIP code entered, improving UX and reducing human error.

---

## 📁 Project Structure

```
force-app/
└── main/
    └── default/
        ├── classes/
        │   ├── StockMovementHandler.cls
        │   ├── CpfCnpjValidator.cls
        │   ├── AddressIntegrationService.cls
        │   └── TaskLifecycleManager.cls
        ├── triggers/
        │   ├── StockMovementTrigger.trigger
        │   └── OrderTrigger.trigger
        └── flows/
            └── OrderApprovalProcess.flow
```

---

## 🚀 Getting Started

### Prerequisites

- Salesforce Developer Org or Sandbox
- [Salesforce CLI](https://developer.salesforce.com/tools/sfdxcli) installed
- Git

### Deployment

```bash
# Clone the repository
git clone https://github.com/your-username/inventory-management-system.git

# Authenticate with your Salesforce org
sf org login web --alias my-org

# Deploy to org
sf project deploy start --source-dir force-app --target-org my-org
```

---

## 📌 Notes

- CPF/CNPJ validation follows official Brazilian government digit-verification algorithms.
- Address integration requires outbound network access to be enabled in your Salesforce org's **Remote Site Settings**.
- Approval workflows may require additional configuration of user roles and queues.

---

<div align="center">

Built with ❤️ on the Salesforce Platform

</div>