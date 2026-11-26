# ADR-007 - Secretless SOAR and Human-Controlled Response

## Status

Accepted for lab implementation.

## Context

Security incidents require consistent classification and response.
Stored application credentials introduce unnecessary security risk.
Uncontrolled automated remediation may disrupt critical workloads.

The installed AzureRM provider does not expose the required
alternative authentication property for Sentinel API connections.

## Decision

- Use Sentinel automation rules for incident classification.
- Use Logic Apps Consumption for response orchestration.
- Use system-assigned managed identity for API authentication.
- Scope RBAC permissions to required resources.
- Deploy the Sentinel API connection through a Terraform-managed
  ARM template using alternative authentication.
- Use authenticated ARM API calls to create incident comments.
- Retain human approval before destructive remediation.
- Initially enable playbook invocation for governance incidents only.

## Alternatives Considered

| Alternative | Decision |
|---|---|
| Manual incident handling | Rejected as sole response mechanism |
| Client secret authentication | Rejected |
| Manual portal configuration | Rejected for reproducibility |
| Terraform with AzAPI | Valid alternative |
| Terraform-managed ARM deployment | Accepted |
| Fully automated remediation | Deferred |

## Benefits

- Reduced credential exposure.
- Repeatable infrastructure deployment.
- Consistent incident handling.
- Auditable automated response.
- Scoped workload authorization.

## Trade-offs and Residual Risks

- Duplicate events may cause repeated playbook executions.
- Managed identity permissions require lifecycle governance.
- Connector compatibility may vary by region.
- ARM template deployment introduces additional IaC complexity.
- Log ingestion and detection introduce response latency.
- Production workflows require retry and failure monitoring.

## Validation

Two successful Logic Apps executions and two verified
incident comments demonstrate functional end-to-end SOAR.

## Future Improvements

- Correlation-based incident grouping.
- Idempotent playbook actions.
- Approval-based remediation.
- Playbook failure alerting.
- Continuous detection and response testing.
