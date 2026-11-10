# MediTrust: Blockchain-Based Pharmaceutical Supply Chain Verification

## Overview
MediTrust is a decentralized smart contract solution deployed on Ethereum (Solidity v0.8.20) designed to prevent counterfeit pharmaceuticals, enforce role-based access control (RBAC), and manage DRAP emergency product recalls.

## Core Features
* **Role-Based Access Control (RBAC):** Restricts actions across Regulator (DRAP), Manufacturer, Distributor, and Pharmacy nodes.
* **Batch Registration & Custody Tracking:** Verifies handoffs across supply chain tiers.
* **Automated Counterfeit Alerts:** Flags duplicate QR package scans.
* **Emergency Recalls:** Absolute circuit-breaker lock for recalled batches.

## Project Files
* `MediTrust.sol` - Core Smart Contract Code
* `MediTrust_Phase2_Final_Report.pdf` - Complete Technical Report & Execution Logs

## Tech Stack
* **Language:** Solidity v0.8.20
* **IDE / Testing Environment:** Remix IDE
