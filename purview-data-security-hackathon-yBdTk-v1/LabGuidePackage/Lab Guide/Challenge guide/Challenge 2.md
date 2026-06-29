# Challenge 02: Data Loss Prevention (DLP)

**Estimated Duration:** 1 hour

---

## Scenario

Following the recent exposure event, your response team must reduce the ways sensitive business data can leave the organization. You will configure Microsoft Purview Data Loss Prevention controls to protect email, files, collaboration messages, and endpoint activity — creating a practical DLP policy set that blocks risky sharing, notifies users, and produces evidence for the investigation team.

---

## What You Need to Do

Build DLP coverage across the following Microsoft 365 workloads:

1. Exchange Online, SharePoint Online, and OneDrive
2. Microsoft Teams chat and channel messages
3. Endpoint devices (where tenant prerequisites are met)
4. Review alerts and Activity explorer reporting evidence

---

## Task 1: Access the Lab Environment and Review the DLP Scope

**Portals:**
- Microsoft Purview: [https://purview.microsoft.com](https://purview.microsoft.com)
- Azure Portal: [https://portal.azure.com](https://portal.azure.com)

Sign in using the lab credentials at the top of this guide. Then:

1. In Microsoft Purview, navigate to **Solutions** > **Data loss prevention**
2. Open the **Overview** page and note any visible policy sync or device status indicators
3. Select **Policies** and review any existing policies from Challenge 1 or tenant pre-staging
4. Confirm that the following locations are available in your environment:
   - Exchange email
   - SharePoint sites
   - OneDrive accounts
   - Teams chat and channel messages
   - Devices

> **Important:** If **Devices** or **Teams chat and channel messages** is not available as a location, continue with the available locations and note the gap in your evidence folder.

> **Note:** Microsoft Learn documents that DLP policies can target Exchange, SharePoint, OneDrive, Teams, and devices when tenant and licensing prerequisites are in place.

---

## Task 2: Create DLP Protection for Exchange, SharePoint, and OneDrive

Navigate to **Data loss prevention** > **Policies** > **Create policy** and create the following policy.

### Policy Settings

| Setting | Value |
|---|---|
| Template | Custom policy |
| Policy name | `Hackathon - Financial DLP` |
| Description | Protects sensitive financial data across Exchange, SharePoint, OneDrive, and Teams |
| Locations | Exchange email, SharePoint sites, OneDrive accounts |
| Mode | Simulation (with policy tips visible) |

### Rule: Financial Data Detection

Configure a rule within this policy with the following settings:

| Setting | Value |
|---|---|
| Rule name | `Financial Data Detection` |
| Condition 1 | Content contains **Credit Card Number** (Sensitive info type) |
| Condition 2 | Content is shared **with people outside my organization** |
| Action | Restrict access — **Block only people outside your organization** |
| User notifications | Enabled — Email notifications + Policy tips |

> **Note:** If additional financial sensitive info types are unavailable, use **Credit Card Number** and continue.

> **Tip:** Microsoft Learn recommends simulation mode for testing before enforcing restrictions broadly. Policy tips remain visible to users even in simulation mode.

After creating the policy, verify on the **Policies** page that `Hackathon - Financial DLP` shows:
- Locations: Exchange email, SharePoint sites, OneDrive accounts
- Rule: Financial Data Detection
- Mode: Simulation

<validation step="DLP policy coverage and expected protective settings/evidence"/>

---

## Task 3: Extend DLP Controls to Microsoft Teams and Endpoint Devices

### Part A — Add Teams Protection

Edit the existing `Hackathon - Financial DLP` policy and extend coverage:

- Add **Teams chat and channel messages** as an additional location
- Submit the policy update and confirm it is reflected in the policy list

> **Important:** Teams message protection requires the **Teams chat and channel messages** location. Files shared through Teams are protected via SharePoint and OneDrive.

### Part B — Create an Endpoint DLP Policy

Create a second DLP policy targeting endpoint devices.

**Policy settings:**

| Setting | Value |
|---|---|
| Template | Custom policy |
| Location | **Devices** |
| Policy mode | Simulation |

**Rule: Financial Data Detection - Devices**

| Setting | Value |
|---|---|
| Rule name | `Financial Data Detection - Devices` |
| Condition | Content contains **Credit Card Number** (Sensitive info type) |

**Device activity restrictions (under Actions > Audit or restrict activities on devices):**

| Activity | Action |
|---|---|
| Copy to clipboard | Block |
| Copy to removable USB device | Block |
| Copy to a network share | Audit only |
| Print | Audit only |

Verify the new policy is listed on the Policies page after creation.

> **Note:** Endpoint DLP enforcement depends on device onboarding and policy scoping. Both the targeted user and targeted device must be in scope per Microsoft Learn.

<validation step="DLP policy coverage and expected protective settings/evidence"/>

---

## Task 4: Review Alerts, Activity Explorer Evidence, and Policy Outcomes

In Microsoft Purview, navigate back to **Data loss prevention** and review available reporting:

1. **Overview page** — review summary tiles: policy sync status, top activities, device status
2. **Activity explorer** — filter for DLP-related activities and look for:
   - DLP rule matched events
   - User override activity (if enabled)
   - Endpoint egress activity (if endpoint DLP is configured)
3. If seeded activity is available, inspect a result and note: matched policy, rule, user, workload, and timestamp
4. **Alerts** — check whether any incidents or alerts are present for your policies

If no live alerts or activity is visible yet, note that DLP policies generally take approximately one hour to take effect after being turned on.

**Evidence to collect for your incident package:**
- Policy name and locations
- Notification/policy tip configuration
- Any alert, incident, or Activity explorer entry
- Any endpoint evidence or prerequisite gaps observed

> **Tip:** Activity explorer shows detailed endpoint actions such as copy to USB, clipboard, print, or network share when devices are onboarded.

> **Note:** Exchange DLP evaluates new email messages only — it does not retroactively scan existing mailbox content for alert generation.

<validation step="DLP policy coverage and expected protective settings/evidence"/>

---

## Summary

In this challenge, you created and configured Microsoft Purview DLP protection across Exchange, SharePoint, OneDrive, Teams, and endpoint devices. You enabled user-facing notifications and policy tips, added blocking and restriction logic for risky external sharing, extended coverage to Teams messages, applied device-level restrictions, and reviewed the reporting surfaces used to confirm policy effectiveness. These DLP controls now form the operational baseline the team will use during later investigation and remediation challenges.
