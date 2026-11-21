# Directory Groups and Enterprise Application Access — Day 2

**Lab date:** 2026-11-20  
**Evidence type:** Retrospective record of performed activities, supplemented by read-only verification on Day 3.  
**Status:** Configuration implemented; interactive assignment enforcement not tested until Day 3.

## Objective
Extend the synchronized identity baseline to group topology and an enterprise application whose access requires explicit user assignment. Identify nested-group effective-access limitations.

## Implemented work

1. Corrected an AD time synchronization issue during the lab.
2. Configured or validated Cloud Sync group provisioning and group membership.
3. Created or retained the security groups `ZT-Lab-Readers` and `ZT-Lab-App-Access`.
4. Confirmed nested group topology through Microsoft Graph (read-only verification captured on Day 3):

```text
ZT-Lab-App-Access
   └── ZT-Lab-Readers
         └── zt-reader01
```

5. Created the application `ZT-Lab-Test-App` and its Entra service principal.
6. Enabled **Assignment required = True** (`appRoleAssignmentRequired`).
7. Assigned `zt-reader01` directly to the application, using its default-access role.
8. Reviewed licensing constraints: the tenant was operating with Entra ID Free / no subscribed SKU reported; Conditional Access enforcement was not configured.

## Read-only verification used in follow-up

```powershell
# Requires authenticated Microsoft Graph PowerShell context with suitable read scopes.
$spId = '<SERVICE_PRINCIPAL_OBJECT_ID>'
$app = Invoke-MgGraphRequest -Method GET `
  -Uri "https://graph.microsoft.com/v1.0/servicePrincipals/$spId"
$app['displayName']
$app['appRoleAssignmentRequired']

$assignments = Invoke-MgGraphRequest -Method GET `
  -Uri "https://graph.microsoft.com/v1.0/servicePrincipals/$spId/appRoleAssignedTo"
$assignments['value'] | ForEach-Object {
  [PSCustomObject]@{
    Principal = $_['principalDisplayName']
    Type = $_['principalType']
    RoleId = $_['appRoleId']
  }
}
```

**Verified on Day 3:** `ZT-Lab-Test-App` had `Assignment required = True`; its single app assignment was a **direct user** assignment for `zt-reader01` with default access (`00000000-0000-0000-0000-000000000000`). `zt-operator01` had no direct assignment.

## Security architecture finding
Nested membership does not automatically confer enterprise application authorization through a parent group's assignment. **Do not count nested group members as authorized application assignees.** The successful assigned-user test in Day 3 depended on a **direct user assignment**, not nested-group inheritance.

## Scope and limitations
- Day 2 confirmed the application and access-control configuration, not real OAuth allow/deny enforcement.
- Actual sign-in validation was completed on **Day 3**, with authorized code issuance for `zt-reader01` and `AADSTS50105` denial for `zt-operator01`.
- No Conditional Access or PIM enforcement is claimed for this unlicensed tenant.
- These retrospective notes should not be presented as raw command transcripts from Day 2.

## Follow-on dependency
See `identity/day3-authorization-evidence.md` and `tests/day3-control-matrix.md` for the actual sign-in outcomes and evidence distinctions.
