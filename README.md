# Hybrid & Multi-Cloud Zero Trust Architecture Lab

A security architecture reference implementation developed as a hands-on lab, emphasizing **deployed vs. proposed controls**, reproducible validation, and implementation tradeoffs. This portfolio currently documents the Microsoft Entra hybrid identity and enterprise application authorization portion of the broader Azure/AWS Zero Trust roadmap.

## Progress and verified outcomes

| Session | Date | Implementation | Validation status |
|---|---|---|---|
| Day 1 — Hybrid identity | 2026-11-19 | AD DS, Entra Cloud Sync, Password Hash Sync, synchronized test users | Agent/configuration healthy; cloud sign-in after AD password reset passed |
| Day 2 — App authorization setup | 2026-11-20 | Cloud Sync groups, nested topology, enterprise app with assignment required and direct user assignment | Settings and membership verified; actual sign-in deferred to Day 3 |
| Day 3 — Authorization tests | 2026-11-21 | OAuth/PKCE flow and minimal Microsoft Graph delegated consent | Assigned user reached authorization code issuance; unassigned user denied with AADSTS50105 after consent |

## Deployed, verified and proposed

**Verified:** Cloud-synchronized identities, direct application assignment, app assignment requirement, and observed positive/negative OAuth authorization behavior. The positive test reached code issuance, **not token redemption or a functioning application session**.

**Proposed, not deployed:** Conditional Access using phishing-resistant MFA, privileged access/PIM, detection and response improvements, and other Zero Trust capabilities requiring additional setup or licensing. Nested group effective app authorization was **not** validated; the authorized user had a direct assignment.

## Repository map

- `identity/day1-hybrid-identity-cloud-sync.md` — Day 1 architecture, verification and scope
- `identity/day2-groups-application-assignment.md` — Day 2 group structure and assignment baseline
- `identity/day3-authorization-evidence.md` — Day 3 observed authorization results
- `tests/day1-day2-validation-matrix.md` — retrospective verification boundaries
- `tests/day3-control-matrix.md` — Day 3 security-control evidence
- `threat-model/day3-threat-register.md` — security threat analysis
- `architecture/ADR-005-identity-access-protection.md` — identity-protection target architecture

Future folders for Azure, AWS, security operations, and resilience will be populated as work is completed.

## Evidence handling

This repository uses sanitized technical summaries: no passwords, secrets, tokens, authorization codes, PKCE verifiers, tenant object GUIDs, or unredacted logs. Days 1 and 2 were documented retrospectively from session notes and subsequent verification. Treat those documents as reconstructed records, not immutable raw logs.
