# Day 3 — Identity Authorization and Zero Trust Design

This folder contains a sanitized employer-facing evidence pack for the **Hybrid & Multi-Cloud Zero Trust Architecture Lab** (2026-11-21).

## Demonstrated
- On-premises synced lab users discovered in Microsoft Graph.
- Explicit enterprise application assignment required.
- A directly assigned test user reached OAuth authorization-code issuance after minimal delegated consent.
- Unassigned test user was denied (`AADSTS50105`) both before and after admin consent.
- Nested group topology discovered; no claim of nested-group effective app access.

## Designed, not deployed
- Conditional Access policy requiring phishing-resistant MFA.
- Centralized detection and response procedures.
- Emergency-access and rollout controls.

## Files
- `identity/day3-authorization-evidence.md`
- `threat-model/day3-threat-register.md`
- `architecture/ADR-005-identity-access-protection.md`
- `tests/day3-control-matrix.md`

## Evidence handling
This pack deliberately contains no passwords, secrets, authorization codes, token material, tenant GUIDs, or unsanitized screenshots. It is a summary of user-observed lab results, not an independent verification of the tenant.
