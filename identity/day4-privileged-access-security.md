# Day 4 — Privileged Identity and Azure RBAC Security

## Objective
Validate least-privilege administration, identify excessive
standing privileges, and establish emergency recovery access.

## Environment
- Microsoft Entra ID Free
- Hybrid identity using Entra Cloud Sync
- Azure subscription with existing RBAC assignments
- Microsoft Graph PowerShell and REST API

## Implemented Controls

### 1. Privileged Role Inventory
Enumerated Entra administrative role definitions, active
assignments, principals, and directory scopes.

Identified tenant-wide administrative assignments.

### 2. Delegated Administration
Created a dedicated cloud-only Helpdesk Administrator.

Validated:
- Administrative role assignment
- Account enabled status
- Successful standard user password reset
- Restricted administrative operations through the portal

### 3. Azure RBAC Assessment
Identified:
- Subscription Owner assignment
- Root-level User Access Administrator assignment
- Terraform service principal with subscription Reader access

### 4. Root Privilege Remediation
Disabled unnecessary elevated access under:
Microsoft Entra ID > Properties >
Access management for Azure resources

Result:
- Root-level UAA assignment removed
- Subscription Owner assignment retained
- Terraform Reader assignment retained

### 5. Emergency Access
Created two independent cloud-only emergency accounts.

Validated:
- Global Administrator role assignments
- Successful independent sign-ins

Further hardening:
- Independent strong authentication
- Secure credential storage
- Emergency sign-in monitoring

## Architecture Design Only
The following controls were not deployed:
- Privileged Identity Management
- Conditional Access
- Identity Protection
- Risk-based authentication policies

Reason: Entra ID P2 trial activation was unsuccessful.

## Security Considerations
- Avoid permanent operational privileged assignments.
- Restrict administrative scope wherever possible.
- Separate operational and emergency identities.
- Protect emergency accounts from lockout dependencies.
- Monitor every emergency account sign-in.
- Review remaining subscription-level Owner privileges.

## Outcome
Identified and remediated excessive root-level Azure access.
Implemented delegated administration and emergency access
recovery capabilities without additional licensing.

## Evidence
Validation performed through Microsoft Graph and Azure Portal.
Public documentation intentionally excludes credentials,
temporary passwords, tenant identifiers, and sensitive screenshots.
