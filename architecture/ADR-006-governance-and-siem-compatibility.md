# ADR-006: Governance and SIEM Compatibility

## Status
Accepted and validated.

## Context
The mandatory Environment=Lab tagging policy prevented
Microsoft Sentinel onboarding because the Azure-managed
SecurityInsights solution did not satisfy the tag requirement.

## Decision
Add a resource-specific exclusion to the existing Terraform-managed
tagging policy assignment for the Sentinel solution.

Retain policy enforcement and the Qatar Central location restriction.

## Alternatives considered
- Disable the tagging policy: rejected.
- Temporarily disable policy enforcement: rejected.
- Exclude all managed solutions: rejected as unnecessarily broad.
- Exclude the specific Sentinel solution: accepted.

## Validation
- Policy assignment updated without resource destruction.
- Microsoft Sentinel onboarding succeeded.
- Untagged NSG deployment was denied.
- Tagged NSG deployment succeeded.
- Test NSG was successfully deleted.

## Residual risks
The excluded solution is not evaluated against the mandatory tag policy.
The exception must be reviewed during architecture lifecycle changes.

The location policy was not regression-tested during this session.
