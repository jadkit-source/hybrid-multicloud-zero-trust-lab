# Day 9 - Security Orchestration and Automated Response

Date: 2026-11-26

## Objectives

- Optimize Sentinel scheduled detection rules.
- Implement incident automation using Terraform.
- Deploy a Logic Apps Consumption playbook.
- Implement secretless workload authentication.
- Validate end-to-end security response.

## Implemented Architecture

Azure Policy
  -> Azure Activity Logs
  -> Log Analytics
  -> Sentinel Analytics Rules
  -> Sentinel Automation Rules
  -> Logic Apps Playbook
  -> Incident Investigation Comment
  -> Human Investigation

## Detection Optimization

- Query frequency: 5 minutes.
- Query period: 30 minutes.
- Added ingestion-time filtering.
- Added resource ID fallback using _ResourceId.
- Reduced repeated detections in initial testing.

## Automation Rules

| Rule | Tags | Playbook |
|---|---|---|
| Governance | Governance, TriageRequired | Enabled |
| Privileged Access | PrivilegedAccess, TriageRequired | Not configured |
| Network Security | NetworkSecurity, TriageRequired | Not configured |

## Workload Identity

- System-assigned managed identity for Logic Apps.
- Microsoft Sentinel Responder at workspace scope.
- Microsoft Sentinel Automation Contributor at resource group scope.
- No stored passwords or client secrets.

## Runtime Results

- Governance incidents 16 and 19 successfully processed.
- Two Logic Apps executions succeeded.
- Both incidents received automated investigation comments.
- Execution duration approximately 4 seconds per run.
- Incidents remained open for human investigation.

## Known Limitations

- Exactly-once event processing is not guaranteed.
- Duplicate incident root cause requires further correlation.
- Playbook idempotency is not implemented.
- Production deployment requires additional monitoring,
  incident grouping and failure-handling controls.
- Automated destructive remediation is intentionally excluded.

## Outcome

End-to-end SOAR functionality successfully validated.
