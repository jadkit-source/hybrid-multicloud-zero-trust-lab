# Day 9 - SOAR Validation Matrix

Date: 2026-11-26

| ID | Security Control | Result |
|---|---|---|
| SOAR-01 | Azure Policy blocks untagged resources | PASS |
| SOAR-02 | Azure Activity Log ingestion | PASS |
| SOAR-03 | Policy denial detection | PASS |
| SOAR-04 | RBAC modification detection | PASS |
| SOAR-05 | NSG modification detection | PASS |
| SOAR-06 | Governance incident tagging | PASS |
| SOAR-07 | Privileged access incident tagging | PASS |
| SOAR-08 | Network incident tagging | NOT TESTED |
| SOAR-09 | Logic Apps managed identity deployment | PASS |
| SOAR-10 | Workspace-scoped Responder RBAC | PASS |
| SOAR-11 | Sentinel playbook invocation RBAC | PASS |
| SOAR-12 | Managed identity API connection | PASS |
| SOAR-13 | Automatic playbook invocation | PASS |
| SOAR-14 | Automated incident comment | PASS |
| SOAR-15 | Human-controlled remediation | PASS |
| SOAR-16 | Exactly-once detection | PARTIAL |
| SOAR-17 | Playbook idempotency | NOT IMPLEMENTED |

## Runtime Evidence

- Two governance incidents processed.
- Two successful playbook executions.
- Two verified automated incident comments.
- Playbook execution duration: 3.69 and 4.06 seconds.
- No destructive remediation performed.

## Detection Investigation

Six-hour Azure Activity summary:

| Operation | Status | Events | Unique Event IDs |
|---|---|---:|---:|
| Policy denial | Failure | 3 | 3 |
| RBAC modification | Start | 2 | 2 |
| RBAC modification | Success | 2 | 2 |

No repeated event IDs were identified within the summarized groups.
Exact incident duplication root cause remains unconfirmed.

## Overall Result

Functional SOAR validation: PASS.

Production readiness: Additional engineering required.

Raw identity claims, access tokens, IP addresses and tenant-specific
identifiers are excluded from published evidence.
