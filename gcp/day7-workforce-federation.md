# Day 7 - Entra ID to GCP Workforce Federation

## Architecture
On-premises AD -> Entra Cloud Sync -> Microsoft Entra ID
-> OIDC Workforce Federation -> Google Cloud IAM

## Implementation
- GCP organization: jadkit-org
- Project: hybrid-zt-lab
- Workforce pool: zt-entra-workforce
- Provider: entra-oidc
- Protocol: OIDC authorization code flow
- Subject mapping: assertion.oid
- Group mapping: assertion.groups
- Provider condition: Entra tenant + ZT-GCP-Readers membership
- IAM role: roles/viewer
- IAM principal: Federated ZT-GCP-Readers group

## Troubleshooting
Initial OIDC authentication failed because the GCP
Client ID contained one additional leading whitespace
character. Correcting the Client ID resolved the
audience validation error.

The Entra application used direct user assignment
because group application assignment was unavailable
under the current licensing.

## Validation Results
PASS - Entra ID token accepted by GCP
PASS - Subject and group claims mapped
PASS - Federated zt-reader01 CLI authentication
PASS - GCP project describe
PASS - resourcemanager.projects.get allowed
PASS - resourcemanager.projects.setIamPolicy absent
       from effective permissions

## Security Notes
- No permanent GCP credentials required for the test user
- GCP IAM authorization uses group-based principalSet
- Admin and federated CLI configurations are separate
- No access tokens, secrets, or full ID tokens stored
- Actual IAM modification was not attempted
