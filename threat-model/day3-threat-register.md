# Day 3 Threat Register — Hybrid Identity and Application Access

**Date:** 2026-11-21  
**Status:** Architecture-level analysis. Initial/residual ratings are qualitative scenario assumptions, not calculated risk scores. Proposed controls are not deployed unless specifically recorded as observed.

| ID | STRIDE | Threat / attack path | Initial likelihood | Initial impact | Implemented & observed | Proposed mitigation | Residual risk (conditional) | Validation needed |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| T-001 | Elevation of privilege | Unassigned identity attempts application access | Medium | High | `appRoleAssignmentRequired = true`; `zt-operator01` blocked `AADSTS50105` both before and after admin consent | Audit assignment changes; recertify entitlements | Low for tested OAuth flow | Review privileged bypass paths, additional clients and app endpoints |
| T-002 | Elevation of privilege | Nested group mistaken for effective application authorization | Medium | Medium | Nested group relationship observed, not enforced/tested | Explicit direct user or direct-member group assignment; avoid reliance on nested groups | Low only if design enforced | With P1/P2, positive/negative direct-versus-nested membership tests |
| T-003 | Spoofing | Attacker knows assigned user's password and authenticates | High | High | Direct app assignment exists; no CA MFA evidence | Phishing-resistant MFA authentication strength, scoped assignments, SIEM sign-in alerting | Medium, estimated after implementation | Simulated stolen-password exercise and CA/credential registration evidence |
| T-004 | Elevation of privilege | Excessive delegated/application API permissions or unauthorized consent | Medium | High | Only Graph delegated `User.Read` configured and admin-consented for this app | Maintain consent review, audit grants, prohibit unnecessary app permissions | Low–Medium if governed | Review service principal permission grants and change logs |
| T-005 | Spoofing / information disclosure | Stolen browser session or token used after successful authentication | Medium | High | No token protection or session revocation tests | Secure endpoint, session restrictions where supported, detect token anomalies, revoke sessions, recover device | Medium–High | Incident response tabletop, token theft detections, revocation verification |
| T-006 | Denial of service | Mis-scoped CA policy locks out operators/admins | Medium | High | No CA policy deployed | Emergency access accounts, scope review, report-only pilot, staged enforcement | Medium if implemented correctly | Break-glass sign-in and rollback drill |

## Key interpretation

- **Prevention:** credential-resistant authentication, scoped assignment, consent governance, hardened devices.
- **Detection:** identity sign-in signals, role and app assignment changes, permission-grant audit events.
- **Response and recovery:** isolate affected device, revoke sessions, reset credentials as indicated, remove improper access, validate restoration and emergency access.
- **Residual limitations:** Conditional Access MFA, session defenses, monitoring integrations, and recovery drills are proposed rather than tested in this lab.

## Source guidance

- https://learn.microsoft.com/en-us/entra/identity/conditional-access/policy-admin-phish-resistant-mfa
- https://learn.microsoft.com/en-us/entra/identity/conditional-access/plan-conditional-access
- https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/what-is-access-management
