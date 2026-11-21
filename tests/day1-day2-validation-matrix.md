# Day 1–2 Retrospective Validation Matrix

| ID | Day | Control / procedure | Result | Evidence quality / boundary |
|---|---|---|---|---|
| HID-01 | 1 | Cloud Sync agent active and provisioning configuration healthy | Passed | User-observed health/status in lab |
| HID-02 | 1 | PHS enabled | Passed | Configuration state, not a full DR test |
| HID-03 | 1 | Two test identities provisioned | Passed | Corroborated by later Graph reads |
| HID-04 | 1 | Updated AD password used for cloud sign-in | Passed | User-observed sign-in after AD password reset |
| HID-05 | 2 | AD time synchronization issue corrected | Completed | Retrospective session record; raw diagnostic logs not preserved |
| IAM-01 | 2 | Nested group topology configured | Passed | Read-only Graph verification on Day 3 |
| IAM-02 | 2 | Application assignment required | Passed | Graph service principal property verified on Day 2 and Day 3 |
| IAM-03 | 2 | `zt-reader01` assigned directly | Passed | Graph appRoleAssignedTo verified on Day 3 |
| IAM-04 | 2 | Real authorized/denied sign-in | Not tested on Day 2 | Performed Day 3; see separate Day 3 evidence |
| CA-01 | 2 | Conditional Access policy | Not deployed | Licensing dependency; design-only work on Day 3 |

**Evidence hygiene:** These notes summarize previously observed results and explicitly call out later corroboration; they are not source logs. Do not include raw tenant IDs, passwords, app secrets, PKCE verifier values, authorization codes, or tokens in the public repository.
