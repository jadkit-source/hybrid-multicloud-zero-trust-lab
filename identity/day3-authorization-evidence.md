# Hybrid & Multi-Cloud Zero Trust Lab — Identity Authorization Evidence

**Date:** 2026-11-21  
**Scope:** Microsoft Entra hybrid-synchronized test identities and `ZT-Lab-Test-App`  
**Evidence status:** Configuration and OAuth authorization behavior observed; no application session or API token redemption tested.

## Lab configuration

- On-premises identities `zt-reader01` and `zt-operator01` show `onPremisesSyncEnabled = true` in Entra ID.
- Enterprise application `ZT-Lab-Test-App` has `appRoleAssignmentRequired = true`.
- `zt-reader01` has a **direct user assignment** to the app's Default Access role (`00000000-0000-0000-0000-000000000000`).
- `zt-operator01` has **no direct assignment**, and the app's assignment listing contained only `zt-reader01`.
- Group structure observed: `ZT-Lab-App-Access` contains `ZT-Lab-Readers`; `ZT-Lab-Readers` directly contains `zt-reader01`. This nested path was **not** tested as application authorization and is not a supported substitute for direct group membership in Entra app group assignment.
- App configured with public-client redirect URI `http://localhost` for temporary OAuth authorization-code + PKCE testing.
- App configured with Microsoft Graph delegated `User.Read`; tenant-wide administrator consent later recorded as granted.
- Tenant subscription SKU listing returned zero items. Conditional Access and group-based app assignment **were not deployed or tested**.

## Test evidence matrix

| Test ID | Test | Expected | Observed | Result |
| --- | --- | --- | --- | --- |
| IAM-01 | Synced identity discovery | Lab accounts visible and synced | Both account records showed `onPremisesSyncEnabled = true` | PASS |
| IAM-02 | Assignment requirement | App requires assignment | Graph returned `appRoleAssignmentRequired = true` | PASS |
| IAM-03 | Direct positive assignment | `zt-reader01` assigned | App role listing contains direct user assignment | PASS |
| IAM-04 | Negative OAuth authorization before consent | Unassigned `zt-operator01` blocked | `AADSTS50105` | PASS |
| IAM-05 | Consent governance | Minimal delegated scope and admin consent | `User.Read` delegated, marked `Granted for JadkitA` | PASS |
| IAM-06 | Positive OAuth authorization after consent | Assigned user receives code | Browser redirected to `localhost/?code=...`; localhost listener absent (`ERR_CONNECTION_REFUSED`) | PASS (code issuance only) |
| IAM-07 | Negative OAuth authorization after consent | Unassigned user still blocked | `AADSTS50105` | PASS |
| IAM-08 | Conditional Access phishing-resistant MFA | Policy applies and is enforced | Not deployed; no subscribed SKUs | NOT TESTED |
| IAM-09 | Nested-group application authorization | Nested membership alone should not grant app assignment | No group-assignment enforcement test performed | NOT TESTED |
| IAM-10 | End-to-end app sign-in and API use | Authorization code redeemed, token validated by app | No local listener or application session | NOT TESTED |

## Security interpretation

Successful OAuth code issuance indicates that the authorization request passed the applicable Entra checks for the tested identity; it does **not** establish that the code was redeemed or the application created a session. The unassigned user's `AADSTS50105` after administrator consent shows that permission consent does not override assignment requirements.

## Evidence hygiene

- Do not commit full browser URLs, `code=` values, access/ID/refresh tokens, credentials, client secrets, session cookies, raw log exports, or tenant-identifying screenshots.
- Use summarized results and sanitized screenshots that remove URL query strings, user identifiers where not needed, request IDs, and account-specific details.
- The original browser screenshot contained part of an authorization code: **do not publish that image**.
- No proof of deployed Conditional Access, phishing-resistant MFA, device compliance, or production application access is claimed.

## Follow-up validation

1. If appropriate licensing becomes available, create a narrowly scoped CA policy in report-only mode; validate expected impact, emergency access exclusions, and sign-in logs before enabling.
2. Where group-based assignment is licensed, test direct members versus nested-only members and record observed outcomes.
3. Implement a minimal test client with PKCE code redemption if end-to-end token validation is required.

## References

- https://learn.microsoft.com/en-us/troubleshoot/entra/entra-id/app-integration/error-code-aadsts50105-user-not-assigned-role
- https://learn.microsoft.com/en-us/azure/active-directory/manage-apps/assign-user-or-group-access-portal
- https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/application-sign-in-unexpected-user-consent-prompt
