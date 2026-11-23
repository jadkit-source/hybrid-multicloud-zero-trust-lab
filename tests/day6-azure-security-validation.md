# Day 6 - Azure Security Validation

Date: 2026-11-23
Environment: Azure Zero Trust Lab
Resource Group: rg-zt-lab-dev
Region: Qatar Central

## Validated Controls

| Control | Result |
|---|---|
| Terraform init and validate | PASS |
| Terraform state inventory | PASS |
| Key Vault public access disabled | PASS |
| Key Vault RBAC enabled | PASS |
| Key Vault soft delete enabled | PASS |
| Azure Policy negative validation | PASS |
| Azure Policy positive validation | PASS |

## Azure Policy Evidence

Assignments:
- zt-allowed-locations
- zt-required-environment-tag

Allowed region: qatarcentral
Required tag: Environment=Lab
Enforcement mode: Default

Negative test:
- Region: eastus
- Environment: Dev
- Result: RequestDisallowedByPolicy
- Both assignments identified in denial

Positive test:
- Region: qatarcentral
- Environment: Lab
- Result: Succeeded
- Validation level: Provider
- No storage account deployment requested

Limitations:
- Each policy was not tested independently.
- Other policy combinations remain untested.

## Key Vault Findings

- Public network access: Disabled
- Azure RBAC: Enabled
- Soft delete: Enabled
- Retention: 7 days
- Purge protection: Not enabled
- Direct and inherited RBAC assignments inspected
- Data-plane secret access not tested

## Architecture Decisions

ADR-005:
Exclude Private Endpoint from this cost-limited lab.

Consequence:
Key Vault public data-plane connectivity is blocked,
and no private data-plane path has been deployed.

Production recommendation:
Deploy Private Endpoint, Private DNS and
controlled workload connectivity.

ADR-006:
Retain seven-day soft delete without purge protection
for the disposable lab.

Residual risk:
A privileged actor could permanently purge deleted
vault data before the retention period expires.

Production recommendation:
Enable purge protection with an appropriate retention
period and protected recovery procedures.

## Security Conclusion

Preventive Azure Policy governance was validated using
negative and positive provider-level ARM validation.

Key Vault management-plane security configuration was
inspected, but end-to-end data-plane authorization and
private network connectivity remain untested.
