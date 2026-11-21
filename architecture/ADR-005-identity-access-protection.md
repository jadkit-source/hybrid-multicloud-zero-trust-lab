# ADR-005 — Phishing-Resistant Identity and Explicit Application Authorization

- **Date:** 2026-11-21
- **Status:** Proposed (policy not deployed)
- **Decision owner:** Lab architecture exercise; not a production approval
- **Scope:** Hybrid AD DS → Entra Cloud Sync/PHS → Entra enterprise app

## Context

Day 3 verified synchronized identities and a working `Assignment required = true` control for `ZT-Lab-Test-App`. A directly assigned user (`zt-reader01`) reached OAuth authorization-code issuance after administrator consent for delegated Graph `User.Read`; unassigned `zt-operator01` received `AADSTS50105` both before and after consent. An assigned user's stolen password remains a concern because no Conditional Access authentication-strength control was deployed or tested. The tenant returned no subscribed license SKUs.

## Decision

For the target architecture, require phishing-resistant MFA for protected app access using Conditional Access authentication strength where properly licensed; retain explicit application authorization; keep permissions least-privilege; centralize identity audit/alert signals. Use direct supported assignments and do not assume nested group membership grants enterprise app access. Maintain emergency-access procedures and a staged policy rollout.

This is a **design decision**, not an assertion that MFA/CA enforcement currently exists.

## Alternatives considered

1. Password rotation alone — insufficient against phishing, replay and stolen sessions.
2. MFA only from external networks — leaves gaps for compromised devices and internal access; trusted location does not establish trusted identity.
3. Strong MFA + limited assignments + monitoring — selected layered strategy.
4. Rely solely on synchronized identities and admin consent — no defense against misuse by assigned compromised accounts.

## Consequences and tradeoffs

- **Benefits:** less exposure to credential phishing, reduced entitlement reach, actionable detection and response.
- **Costs/dependencies:** Entra ID P1 or eligible licensing, authenticator/key provisioning and recovery support, logging/retention cost and governance, rollout communication.
- **Risks remaining:** token/session theft, endpoint compromise, consent abuse, account recovery social engineering, privileged bypass, and operational lockout.

## Deployment gates

- [ ] Verify appropriate licenses and user coverage; obtain approval if subscription cost required.
- [ ] Provision phishing-resistant methods for selected lab users and a secured recovery path.
- [ ] Exclude designated emergency-access identities through reviewed policy design.
- [ ] Configure a **targeted** app policy in report-only mode; inspect actual outcomes and business impact.
- [ ] Validate successful assigned user with qualifying MFA and failed assigned user lacking required strength.
- [ ] Reconfirm unassigned user denied, independent of consent.
- [ ] Verify audit logging, alert routing, incident workflow, rollback and emergency access.
- [ ] Only then consider enabling policy, with explicit approval.

## Current evidence

See `../identity/day3-authorization-evidence.md` and `../threat-model/day3-threat-register.md`.

## References

- https://learn.microsoft.com/en-us/entra/identity/conditional-access/policy-admin-phish-resistant-mfa
- https://learn.microsoft.com/en-us/entra/identity/conditional-access/plan-conditional-access
- https://learn.microsoft.com/en-us/entra/fundamentals/licensing
