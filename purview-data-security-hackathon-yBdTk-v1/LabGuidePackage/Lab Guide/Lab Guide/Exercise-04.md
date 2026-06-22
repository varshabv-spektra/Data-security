# Exercise 04: Challenge 4 — DSPM & Information Barriers

### Estimated Duration: 45 Minutes

## Scenario

The response team has already deployed foundational labeling, DLP, and investigation controls. Your next objective is to reduce future exposure by using Microsoft Purview Data Security Posture Management (DSPM) to identify posture gaps, focus on AI-related oversharing risk, and apply a segmentation control that limits inappropriate collaboration between sensitive business groups.

## Overview

In this challenge, you will review the organization's current data security posture in Microsoft Purview, inspect AI-related exposure insights and recommendations, document one remediation action, and then configure Information Barriers segments and a blocking policy to reduce risky collaboration paths.

## Objectives

- Task 1: Access Microsoft Purview and review DSPM posture data
- Task 2: Inspect AI-related recommendations and document a remediation action
- Task 3: Create Information Barriers segments
- Task 4: Create and apply an Information Barriers policy
- Task 5: Verify enforcement and capture evidence

## Task 1: Access Microsoft Purview and review DSPM posture data

In this task, you will sign in and review the main DSPM posture experience.

1. From the lab VM, open Microsoft Edge.
2. Sign in to the [Microsoft Purview portal](https://purview.microsoft.com) with the following credentials:
   - Username: `<inject key="AzureAdUserEmail"></inject>`
   - Password: `<inject key="AzureAdUserPassword"></inject>`
3. When prompted, note your deployment reference for evidence tracking as **Deployment ID: <inject key="DeploymentID" enableCopy="false"/>**.
4. In the left navigation pane, select **Solutions**.
5. Open **DSPM**.

> [!Important]
> Microsoft Learn now distinguishes the current **DSPM** experience from **DSPM for AI (classic)**. For this challenge, use **DSPM** if it is available in the tenant. If the lab tenant exposes the classic AI view instead, use the AI-focused recommendations and reports available there to complete the same analysis steps.

6. Review the **Posture** page.
7. Identify the current posture summary, top objectives, and any visible recommendations related to oversharing, exfiltration, or policy gaps.
8. Record the following in your notes file on the lab VM:
   - Current posture observations
   - One high-priority recommendation
   - Any AI-related or Copilot-related risk indicator shown on screen
9. Take a screenshot of the DSPM **Posture** page and save it to your evidence folder.

> [!Tip]
> If sample data is limited in the tenant, focus on the visible workflow areas Microsoft documents for DSPM: **Posture**, **Objectives**, **AI observability**, **Activity explorer**, **Data risk assessments**, and **Remediation actions**.

## Task 2: Inspect AI-related recommendations and document a remediation action

In this task, you will review AI-related recommendations and identify one action the team can take to reduce exposure.

1. While still in **DSPM**, review either the **Objectives** page or the **Recommendations** area that appears in your tenant.
2. Look for recommendations related to AI protection, oversharing, or sensitive-data exposure.
3. If available, open **AI observability** and review which apps, agents, or AI-enabled experiences are listed.
4. Open **Discover** > **Activity explorer** if it is available in your tenant.
5. Review any AI-related activities, sensitive info indicators, or related protection coverage that appear.
6. Open **Discover** > **Data risk assessments** if the tenant has results available.
7. Review the default or custom assessment summary and identify at least one potential oversharing concern, such as:
   - Sensitive items without labels
   - Overly broad sharing
   - Sites or items accessible to too many users
8. Choose one remediation action recommended by DSPM. Examples include:
   - Restrict access by label
   - Create an auto-labeling policy
   - Create or improve a DLP policy
   - Remove risky sharing links
   - Restrict discovery for a site or content set
9. In your evidence notes, document:
   - The recommendation name
   - Why it matters to the incident scenario
   - Whether you implemented it directly in this lab or recorded it as an approved next action
10. Capture a screenshot of the recommendation or data risk assessment details.

> [!Note]
> Microsoft Learn states that some DSPM and DSPM for AI insights depend on background data collection and can take from 24 hours to several days to populate. For hackathon timing, use visible seeded evidence if present and document the remediation decision even if live metrics are still maturing.

<validation step="DSPM / governance progress"/>

## Task 3: Create Information Barriers segments

In this task, you will create user segments to support restricted collaboration between sensitive business groups.

1. In the Microsoft Purview portal, open **Information Barriers** > **Segments**.
2. Select **New segment**.
3. Create the first segment using the best matching pre-staged group or persona for a sensitive business function, such as **Finance**.
4. Provide a segment name such as `Finance-Segment`.
5. On the filter page, add the appropriate condition that maps to the pre-staged users or group in the tenant.
6. Review the configuration and select **Submit**.
7. Repeat the process to create a second segment for another sensitive or incompatible business function, such as **Research** or **Contractors**, based on the personas available in the tenant.
8. Verify both segments appear in the **Segments** list.
9. Record the segment names in your evidence notes.

> [!Important]
> The exact filter options available can vary by tenant configuration. If the tenant already contains pre-created groups for the hackathon personas, use those groups so your Information Barriers design aligns to the seeded scenario.

## Task 4: Create and apply an Information Barriers policy

In this task, you will create a policy that blocks communication between the two segments.

1. In the Purview portal, open **Information Barriers** > **Policies** > **Policies**.
2. Select **Create policy**.
3. Enter a policy name such as `Finance-Research-Block`.
4. When prompted to select the assigned segment, choose the first segment you created in the previous task.
5. On the communication and collaboration configuration page, choose **Blocked** if that option is available for your tenant's policy model.
6. Select the second segment as the blocked segment.
7. Set the policy status to active if the wizard provides that option.
8. Review the configuration and select **Submit**.
9. If your environment requires reciprocal blocking for clear two-way enforcement, create a second block policy in the opposite direction.
10. Open **Information Barriers** > **Policies** > **Policy applications**.
11. Select **Apply all policies**.
12. Wait for the policy application process to start and capture the application status.

> [!Note]
> Microsoft Learn notes that policy evaluation and application can take time, and large tenants may take several hours to fully process. In this hackathon, capture the submitted policy plus the policy application status as your primary evidence if full propagation is not immediate.

## Task 5: Verify enforcement and capture evidence

In this task, you will confirm that the Information Barriers configuration is in place and prepare your incident-hardening evidence.

1. Return to **Information Barriers** > **Policies** and verify your policy is listed.
2. Open the policy details and confirm the assigned segment and blocked segment values are correct.
3. Open **Policy applications** and verify that the latest application cycle reflects your change, or note that evaluation is still in progress.
4. If the tenant provides lookup, reporting, or people-discovery evidence, use it to confirm the segments are now separated as expected.
5. Add the following notes to your evidence log:
   - Segment names created
   - Blocking policy name
   - Policy application status
   - Expected risk reduction for the exposed-data scenario
6. Save at least one screenshot showing the segment list and one screenshot showing the policy or policy application status.
7. Prepare a short incident-response statement explaining how DSPM findings and Information Barriers work together to reduce oversharing risk.

## Summary

In this challenge, you reviewed Microsoft Purview DSPM posture data, investigated AI-related exposure insights and recommendations, documented a remediation action, and implemented Information Barriers segmentation with a blocking policy. These actions strengthen the organization's posture by combining visibility into data risk with a concrete collaboration control that helps prevent future oversharing between sensitive groups.
