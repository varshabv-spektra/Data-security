# Challenge Guide: Microsoft Purview Data Security

> **Environment Reference**
> - Username: <inject key="AzureAdUserEmail"></inject>
> - Password: <inject key="AzureAdUserPassword"></inject>
> - Tenant ID: <inject key="TenantID"></inject>
> - Subscription ID: <inject key="SubscriptionID"></inject>
> - Deployment ID: <inject key="DeploymentID" enableCopy="false"></inject>

---

# Challenge 01: Information Protection & Classification

**Estimated Duration:** 1 hour 15 minutes

---

## Scenario

Your organization is responding to a sensitive data exposure event caused by inconsistent labeling practices, weak protection settings, and overshared files stored across Microsoft 365. As part of the joint data security and compliance response team, you must establish a sensitivity labeling model, publish it to users, enable automatic classification for sensitive content, and confirm that labels are available for SharePoint and OneDrive workloads.

---

## What You Need to Do

Configure the core Microsoft Purview Information Protection controls to harden the tenant:

1. Create a business-aligned sensitivity label taxonomy (4 labels, 2 sublabels)
2. Set label priority to reflect increasing data sensitivity
3. Publish all labels via a label policy
4. Create an auto-labeling policy based on a sensitive information type
5. Verify label support is enabled for SharePoint and OneDrive

---

## Task 1: Sign In and Review the Incident Context

**Portal:** [https://purview.microsoft.com](https://purview.microsoft.com)

Sign in using the lab credentials above. After signing in:

- Navigate to **Solutions** > **Information Protection**
- Familiarise yourself with these sections in the left navigation:
  - **Sensitivity labels**
  - **Policies** > **Label publishing policies**
  - **Policies** > **Auto-labeling policies**

> **Tip:** Save screenshots with filenames that include your Deployment ID so they can be correlated during the investigation summary.

---

## Task 2: Create the Sensitivity Label Taxonomy

Navigate to **Solutions** > **Information Protection** > **Sensitivity labels** and create the following label structure.

### Labels to Create

| Label | Display Name | User Description | Type |
|---|---|---|---|
| `Public` | Public | Use for information approved for broad internal and external sharing. | Top-level |
| `General` | General | Use for standard business information intended for routine internal use. | Top-level |
| `Confidential` | Confidential | Use for sensitive business information that requires controlled access. | Top-level |
| `Finance` | Finance | Use for sensitive financial and payment-related content. | Sublabel of **Confidential** |
| `Legal` | Legal | Use for contracts, legal advice, and privileged legal content. | Sublabel of **Confidential** |
| `Highly Confidential` | Highly Confidential | Use for highly sensitive information, including strategic, executive, regulated, or restricted content that requires the highest level of protection. | Top-level |

**For each label:**
- Scope: **Files & other data assets** and **Emails**
- Leave advanced protection settings at default unless specified

> **Important:** Sublabels (`Finance` and `Legal`) must be created from the **Confidential** parent label's action menu using **Create sublabel** — not as standalone top-level labels.

---

## Task 3: Configure Label Priority

Return to the **Sensitivity labels** list and reorder labels so the least restrictive appears at the top and the most restrictive at the bottom.

**Required label order (top to bottom):**

1. Public
2. General
3. Confidential *(with Finance and Legal nested as sublabels)*
4. Highly Confidential

Confirm that `Confidential / Finance` and `Confidential / Legal` remain grouped under the `Confidential` parent.

> **Note:** Label priority matters in Microsoft Purview. A higher position number (lower in the list) = more restrictive.

<validation step="Information Protection"/>

---

## Task 4: Publish the Labels to Users

Navigate to **Information Protection** > **Policies** > **Label publishing policies** and publish a new policy.

**Policy configuration:**

- **Labels to include:** All six labels created above
  - Public, General, Confidential, Confidential/Finance, Confidential/Legal, Highly Confidential
- **Policy name:** `Challenge 1 Label Policy`
- Scope and settings: Accept defaults unless otherwise specified

Verify that `Challenge 1 Label Policy` appears in the label policies list after creation.

> **Tip:** Publishing a label policy makes labels available to assigned users and services. Replication across Microsoft 365 workloads may take some time.

---

## Task 5: Create an Auto-Labeling Policy

Navigate to **Information Protection** > **Policies** > **Auto-labeling policies** and create a new policy.

**Policy configuration:**

| Setting | Value |
|---|---|
| Policy name | `Challenge 1 Financial Auto-Label` |
| Label to apply | `Confidential/Finance` |
| Locations | SharePoint sites, OneDrive accounts (include Exchange if available) |
| Rule name | `Financial Data Detection` |
| Condition | Content contains **Credit Card Number** (Sensitive info type) |
| Mode | **Simulation** |

> **Note:** If additional financial sensitive information types (e.g., Bank Account Number) are unavailable in your tenant, use **Credit Card Number** and continue.

> **Important:** Simulation mode is recommended by Microsoft Learn so you can validate likely results before enforcing labeling broadly.

---

## Task 6: Enable SharePoint and OneDrive Support and Review Evidence

Verify the configuration you've built so far is complete and consistent:

1. In **Information Protection** > **Sensitivity labels**, confirm all six labels are visible: Public, General, Confidential, Confidential/Finance, Confidential/Legal, and Highly Confidential.
2. In **Policies** > **Label publishing policies**, confirm `Challenge 1 Label Policy` is listed.
3. In **Policies** > **Auto-labeling policies**, confirm `Challenge 1 Financial Auto-Label` is listed and is in **Simulation** mode targeting `Confidential/Finance`.
4. In **Explorers** > **Activity explorer**, note any available label activity or audit status.

> **Note:** In some tenants, propagation delays or licensing constraints may limit what appears in analytics immediately. If live evidence is delayed, capture screenshots of your label and policy configuration as proof of implementation.

<validation step="Information Protection"/>

---

## Summary

In this challenge, you established the foundational Microsoft Purview Information Protection configuration. You created a sensitivity label taxonomy with four top-level labels and two Confidential sublabels, ordered them by sensitivity, published them through a label policy, configured an auto-labeling policy based on a sensitive information type, and verified tenant readiness for SharePoint and OneDrive. These controls form the baseline for later challenges covering DLP, investigations, and incident response.