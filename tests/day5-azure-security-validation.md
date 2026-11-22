# Azure Zero Trust Network and Governance Validation

## Architecture

Resource group: rg-zt-lab-dev
Region: Qatar Central

Components:
- VNet: 10.50.0.0/16
- Workload subnet: 10.50.1.0/24
- Private endpoint subnet: 10.50.2.0/24
- Workload and private endpoint NSGs
- Azure Policy: Allowed locations
- Azure Policy: Required Environment tag
- Azure Key Vault Standard

## Implemented Controls

1. Workload inbound Internet and VNet deny rules.
2. Workload outbound Internet and private endpoint subnet deny rules.
3. Default outbound access disabled on both subnets.
4. Private endpoint subnet network policies enabled.
5. Allowed-locations policy enforced at resource group scope.
6. Required Environment=Lab tag policy enforced.
7. Key Vault public network access disabled.
8. Key Vault configured for Azure RBAC authorization.
9. Key Vault soft delete configured for 7 days.

## Validation Evidence

| Test | Result |
|---|---|
| Terraform network deployment | PASS |
| NSG custom rules verified in Azure | PASS |
| NSG subnet associations | PASS |
| Disallowed region deployment | DENIED as expected |
| Correct location and tag | ALLOWED |
| Missing Environment tag | DENIED as expected |
| Key Vault provisioning | PASS |
| Key Vault public access disabled | PASS |
| Key Vault RBAC enabled | PASS |
| Terraform drift detection | No changes |

## Not Yet Validated

- Live packet-level network isolation
- Key Vault secret data-plane authorization
- Private DNS resolution from a workload
- Private Endpoint connectivity
- Key Vault private access from an approved identity
- Full deny-by-default egress policy

## Architecture Decisions

ADR-005: Use dedicated Azure subnets and NSGs
to establish initial network segmentation.

ADR-006: Apply preventive Azure Policy at resource
group scope to avoid affecting unrelated workloads.

ADR-007: Disable Key Vault public network access
and use Azure RBAC for data-plane authorization.

ADR-008: Keep Private Link deployment optional
until costs and test-client requirements are approved.

## Limitations and Residual Risks

- Default NSG rules permit some traffic not explicitly denied.
- Private endpoint subnet NSG retains default rules.
- No workload-based traffic validation has been performed.
- Private Link is configured but not deployed.
- Key Vault purge protection is disabled for the lab.
- Terraform uses local state and requires secure handling.

## Deployment Status

Deployed: network, NSGs, policies, Key Vault.
Not deployed: Private Endpoint and Private DNS.
