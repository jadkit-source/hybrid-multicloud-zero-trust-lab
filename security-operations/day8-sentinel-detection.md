# Day 8: Security Monitoring and Detection Engineering

## Objective
Implement centralized security monitoring and automated
threat detection using Microsoft Sentinel.

## Deployed architecture
- Azure Log Analytics in Qatar Central.
- Microsoft Sentinel onboarded through Terraform.
- Local workspace authentication disabled.
- Workspace-based access control.
- Public ingestion and query endpoints retained for lab use.
- 30-day workspace retention.
- Daily workspace ingestion cap of 0.1 GB.
- Subscription-level Azure Activity diagnostic settings.
- Eight Azure Activity categories enabled.

## Detection as Code
Three Terraform-managed scheduled analytics rules:

| Rule | Severity | Frequency | Lookback |
|---|---|---|---|
| ZT-001 Azure Policy Denial | Low | 5 minutes | 30 minutes |
| ZT-002 Azure RBAC Modification | Medium | 5 minutes | 30 minutes |
| ZT-003 NSG Rule Modification | Medium | 5 minutes | 30 minutes |

## Observed results
- Administrative events observed: 12.
- Policy denial events observed: 1.
- Automated security alerts generated: 6.
- Sentinel incidents generated: 6.
- Observed time to first alert: approximately 5 minutes 27 seconds.

## Architecture finding
Overlapping detection windows generated repeated alerts
and separate incidents for the same underlying event.

This creates unnecessary SOC workload and alert fatigue.

## Identity integration
Entra diagnostic settings were configured through the portal.
Actual log ingestion remains pending validation.

## Limitations
- Duplicate alerts require detection tuning.
- RBAC and NSG detections are deployed but not tested end-to-end.
- Entra identity detections are not yet deployed.
- GCP telemetry is not connected.
- Public network endpoints remain enabled.
- Ingestion caps are not guaranteed spending limits.
- Terraform state is stored locally for lab purposes.

## Next steps
Investigate incidents, tune detection windows, configure
incident grouping and validate identity log ingestion.
