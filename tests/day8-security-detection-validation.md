# Day 8 Security Detection Validation Matrix

Date: 2026-11-25

| Test | Expected | Actual | Result |
|---|---|---|---|
| Log Analytics deployment | Successful | Successful | PASS |
| Local authentication | Disabled | Disabled | PASS |
| Resource-only permissions | Disabled | Disabled | PASS |
| Initial Sentinel onboarding | Successful | Policy denied | FAIL |
| Targeted policy remediation | Successful | Successful | PASS |
| Sentinel onboarding retry | Successful | Successful | PASS |
| Untagged NSG | Denied | Denied | PASS |
| Tagged NSG | Allowed | Allowed | PASS |
| Test NSG cleanup | Successful | Successful | PASS |
| Azure Activity ingestion | Events available | Events available | PASS |
| Policy violation KQL | Matching event | One matching event | PASS |
| Scheduled rule deployment | Three rules | Three enabled rules | PASS |
| Automated alert generation | Alert generated | Six alerts | PASS |
| Incident generation | Incident generated | Six incidents | PASS |
| Alert deduplication | No duplicate alerts | Duplicate alerts | FAIL |
| Location policy regression | Denied | Not tested | PENDING |
| RBAC detection | Alert generated | Not tested | PENDING |
| NSG detection | Alert generated | Not tested | PENDING |
| Entra diagnostic settings | Configured | Configured | PASS |
| Entra log ingestion | Events available | Not observed | PENDING |

## Evidence summary
A controlled Azure Policy violation generated automated
Microsoft Sentinel alerts and incidents.

The observed duplicate incidents will be used for Day 9
investigation and detection optimization.
