# Day 4 — Privileged Access Validation Matrix

| Test | Expected | Result |
|---|---|---|
| Enumerate Entra role assignments | Success | PASS |
| Resolve assigned principals | Success | PASS |
| Identify tenant-wide role scopes | Success | PASS |
| Verify Helpdesk Administrator role | Assigned | PASS |
| Verify helpdesk account enabled | True | PASS |
| Reset standard user password | Allowed | PASS |
| Create user as Helpdesk Administrator | Denied | PASS - portal |
| Assign privileged role as Helpdesk | Restricted | PASS - portal |
| Reset Global Administrator password | Restricted | PASS - portal |
| Discover root-level UAA | Present | PASS |
| Remove root-level UAA | Absent | PASS |
| Retain subscription Owner | Present | PASS |
| Retain Terraform Reader | Present | PASS |
| Verify two emergency GA assignments | Present | PASS |
| Sign in using emergency accounts | Success | PASS |

## Validation Limitations
Portal restrictions do not independently prove backend
authorization enforcement.

Emergency account sign-ins were tested, but independent
authentication methods and monitoring require further validation.

PIM and Conditional Access remain design-only.

## Residual Risks
- Permanent operational administrative privileges
- Standing subscription Owner privileges
- No deployed PIM controls
- No deployed Conditional Access policies
- Emergency access authentication hardening pending
