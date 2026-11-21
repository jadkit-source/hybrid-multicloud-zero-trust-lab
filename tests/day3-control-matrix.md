# Day 3 Security Control Matrix

| ID | Security objective | Mechanism | Evidence | State |
| --- | --- | --- | --- | --- |
| IAM-01 | Establish hybrid identity source | Entra Cloud Sync / PHS | Two lab users show on-prem sync flag; earlier password reset sign-in tested | Validated |
| IAM-02 | Deny unassigned app access | Enterprise app assignment required | Flag true; AADSTS50105 for unassigned identity | Validated |
| IAM-03 | Permit explicitly assigned user | Direct app role assignment | `zt-reader01` default role; OAuth authorization code issued | Validated for authorization request only |
| IAM-04 | Keep consent separate from entitlement | Delegated Graph User.Read + admin consent | Granted for tenant; unassigned identity still denied | Validated |
| IAM-05 | Avoid nested entitlement assumptions | No reliance on nested app assignment | Nested groups observed; no nested-only sign-in test | Design principle, not tested |
| IAM-06 | Protect assigned credentials | Phishing-resistant authentication strength | No CA deployed, no P1 subscription SKU returned | Proposed only |
| IAM-07 | Detect and respond | SIEM identity detections, review and session revocation | No detections/recovery drill executed | Proposed only |
| IAM-08 | Reduce CA lockout risk | Emergency access + report-only pilot | No CA policy deployed | Proposed only |

Evidence hygiene: do not publish the screenshot displaying `localhost/?code=...` or any token, credential, secret, or raw browser URL.
