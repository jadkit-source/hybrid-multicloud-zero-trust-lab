# Hybrid Identity Baseline — Day 1

**Lab date:** 2026-11-19  
**Evidence type:** Retrospective record based on observed lab outputs and session notes.  
**Status:** Implemented and functionally validated within the stated scope.

## Objective
Establish an on-premises Active Directory identity path into Microsoft Entra ID using Microsoft Entra Cloud Sync and Password Hash Sync (PHS), then validate cloud sign-in following an AD password reset.

## Implemented lab topology

```text
Laptop-hosted VMware NAT network (VMnet8: 192.168.225.0/24)
  LAB-DC01     192.168.225.10   AD DS / DNS, domain ad.lab.test
  LAB-SYNC01   192.168.225.20   Microsoft Entra Cloud Sync agent
       |
       | Scoped provisioning from OU=CloudSyncLab + PHS
       v
  Microsoft Entra tenant (sanitized)
       |
       +-- zt-reader01 (on-premises synchronized)
       +-- zt-operator01 (on-premises synchronized)
```

This diagram represents the observed lab environment, not a production resilient architecture.

## Implementation and observations

1. Set up or used the AD DS and DNS domain `ad.lab.test` and a separate agent VM (`LAB-SYNC01`).
2. Configured Microsoft Entra Cloud Sync with a scoped organizational unit (`OU=CloudSyncLab`).
3. Cloud Sync agent was shown as **Active**, and domain configuration as **Healthy**.
4. Password Hash Sync was **Enabled** and in steady-state processing.
5. Two test users were provisioned to the Entra tenant: `zt-reader01` and `zt-operator01`.
6. An on-premises test password reset was executed for `zt-reader01`; the new password was successfully used for an Entra sign-in.
7. Lab checks also observed a provisioning gMSA/KDS configuration. This record does not expose the account name or secret material.

## Sanitized validation procedure

```powershell
# Executed on an AD management host with the ActiveDirectory module.
$NewPassword = Read-Host 'Enter a new test password' -AsSecureString
Set-ADAccountPassword -Identity 'zt-reader01' -Reset -NewPassword $NewPassword
Get-ADUser 'zt-reader01' -Properties PasswordLastSet |
  Select-Object Name, PasswordLastSet
```

**Observed outcome:** `PasswordLastSet` changed; a subsequent sign-in with the updated test password succeeded for the synchronized user.

## Scope and limitations
- Successful cloud sign-in supports PHS functional validation for the tested identity, not a complete disaster-recovery or PHS-failover test.
- No claim is made that agent-offline authentication, high availability, SSPR writeback, or Conditional Access was tested on Day 1.
- Original portal screenshots and raw log exports are not embedded here; their absence is an evidence limitation.
- Credentials, tenant GUIDs, raw tokens and sign-in codes must not be published.

## Follow-on dependency
Day 2 expands the baseline to groups, nested membership, and explicit application assignment. Day 3 validates live allow/deny authorization behavior.
