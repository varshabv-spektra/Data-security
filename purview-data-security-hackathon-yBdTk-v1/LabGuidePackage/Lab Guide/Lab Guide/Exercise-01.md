# Challenge 01: Information Protection & Classification

### Estimated Duration: 1.25 Hour(s)

## Scenario

Your organization is responding to a sensitive data exposure event caused by inconsistent labeling practices, weak protection settings, and overshared files stored across Microsoft 365. As part of the joint data security and compliance response team, you must establish a usable sensitivity labeling model, publish it to users, enable automatic classification for sensitive content, and confirm that labels are available for SharePoint and OneDrive workloads.

## Overview

In this challenge, you will configure the core Microsoft Purview Information Protection controls required to start hardening the tenant. You will create a business-aligned label taxonomy, add two Confidential sublabels for more precise handling, publish the labels by using a label policy, configure encryption on the most restrictive label, create an auto-labeling policy based on sensitive information types, and verify that label support is enabled for SharePoint and OneDrive.

## Objectives

- Task 1: Sign in and review the incident context
- Task 2: Create the sensitivity label taxonomy
- Task 3: Configure protection settings and label priority
- Task 4: Publish the labels to users
- Task 5: Create an auto-labeling policy
- Task 6: Enable SharePoint and OneDrive support and review evidence

## Task 1: Sign in and review the incident context

In this task, you will sign in to the lab environment and open the Microsoft Purview portal that you will use throughout the challenge.

1. Sign in to the lab VM or browser session with the credentials provided for your environment.
2. Open Microsoft Edge, browse to <https://portal.azure.com>, and sign in with:
   - Username: `<inject key="AzureAdUserEmail"></inject>`
   - Password: `<inject key="AzureAdUserPassword"></inject>`
3. After Azure sign-in completes, open a new tab and browse to <https://purview.microsoft.com>.
4. If prompted to select a tenant or account, confirm that you are working in the tenant associated with:
   - Tenant ID: `<inject key="TenantID"></inject>`
   - Subscription ID: `<inject key="SubscriptionID"></inject>`
5. Record your deployment reference for screenshots and evidence collection as **Deployment ID: <inject key="DeploymentID" enableCopy="false"></inject>**.
6. In the Microsoft Purview portal, select **Solutions** > **Information Protection**.
7. Spend a minute reviewing the left navigation so you can identify these areas used later in the challenge:
   - **Sensitivity labels**
   - **Publishing policies**
   - **Policies** > **Auto-labeling policies**

> [!Tip]
> Save screenshots in your evidence folder using filenames that include your deployment identifier so they can be correlated later during the investigation and remediation summary.

## Task 2: Create the sensitivity label taxonomy

In this task, you will create a label taxonomy with four labels and two sublabels under Confidential.

1. In the Microsoft Purview portal, go to **Solutions** > **Information Protection** > **Sensitivity labels**.
2. Select **+ Create a label**.
3. Create the first label with the following values:
   - **Name**: `Public`
   - **Display name**: `Public`
   - **Description for users**: `Use for information approved for broad internal and external sharing.`
4. For scope, keep the label available for **Files & other data assets** and **Emails**. Continue through the wizard and leave advanced protection settings off for this label unless your tenant already applies defaults.
5. Repeat the process to create a second label named `General` with a user description such as `Use for standard business information intended for routine internal use.`
6. Create a third parent label named `Confidential` with a description such as `Use for sensitive business information that requires controlled access.`
7. Select the **Confidential** label, open the action menu, and choose **Create sublabel**.
8. Create the first sublabel with values similar to the following:
   - **Name**: `Finance`
   - **Display name**: `Confidential \ Finance`
   - **Description for users**: `Use for sensitive financial and payment-related content.`
9. Create a second sublabel under **Confidential** with values similar to the following:
   - **Name**: `Legal`
   - **Display name**: `Confidential \ Legal`
   - **Description for users**: `Use for contracts, legal advice, and privileged legal content.`
10. Create a fourth top-level label named `Highly Confidential`.
11. When configuring **Highly Confidential**, make sure the label scope includes **Files & other data assets** and **Emails**.
12. Finish the label creation wizard and return to the **Sensitivity labels** page.

> [!Important]
> Microsoft Learn guidance notes that sublabels are created from the parent label's action menu rather than as standalone top-level labels. Be sure both Confidential sublabels are nested under the Confidential parent.

## Task 3: Configure protection settings and label priority

In this task, you will configure the most restrictive label to protect content with encryption and ensure label order reflects increasing sensitivity.

1. On the **Sensitivity labels** page, select **Highly Confidential** and choose **Edit label**.
2. Move through the wizard until you reach the protection settings for files and emails.
3. Enable encryption or rights management for the label.
4. Configure the label so that permissions are assigned to specific users or groups, or to all authenticated users with restricted rights, based on what your facilitator has pre-staged for the tenant.
5. If the option is available in your tenant, choose permissions that prevent unauthorized forwarding, printing, or copying for highly sensitive content.
6. Complete the wizard and save the updated label.
7. Return to the **Sensitivity labels** list and review the label order.
8. Reorder the labels so that the least restrictive label is at the top and the most restrictive label is at the bottom. A recommended final order is:
   - `Public`
   - `General`
   - `Confidential`
   - `Highly Confidential`
9. Confirm that the `Confidential \ Finance` and `Confidential \ Legal` sublabels remain grouped under the parent label.
10. Capture a screenshot showing the final taxonomy and priority order.

> [!Note]
> Microsoft Learn states that label priority matters. In the Purview list, the most restrictive label should appear lower in the list, while less restrictive labels should appear higher.

<validation step="Information Protection"/>

## Task 4: Publish the labels to users

In this task, you will publish the labels through a label policy so users and services can consume them.

1. In **Information Protection**, open **Publishing policies**.
2. Select **Publish label**.
3. For the policy name, enter `Challenge 1 Label Policy`.
4. When prompted to choose labels to publish, include all of the labels created in this challenge:
   - `Public`
   - `General`
   - `Confidential`
   - `Confidential \ Finance`
   - `Confidential \ Legal`
   - `Highly Confidential`
5. If your tenant uses groups for scoped rollout, assign the policy to the pre-staged learner or pilot users/group provided by your facilitator. Otherwise, keep the broader scope required for the lab.
6. Continue through the policy settings and review any relevant options for default labeling, mandatory labeling, or policy tips if they are already enabled in the tenant design.
7. Complete the wizard to publish the policy.
8. Return to the **Label policies** page and verify that `Challenge 1 Label Policy` appears in the list.
9. Open the policy and review that the selected labels are included.
10. Capture a screenshot of the published policy details for your evidence folder.

> [!Tip]
> Publishing a label policy makes the labels available to assigned users and services. It can take time for policy replication to complete across Microsoft 365 workloads.

## Task 5: Create an auto-labeling policy

In this task, you will create an auto-labeling policy that applies a sensitivity label when sensitive information is detected.

1. In the Microsoft Purview portal, go to **Solutions** > **Information Protection** > **Policies** > **Auto-labeling policies**.
2. Select **+ Create auto-labeling policy**.
3. Choose the option to **apply a sensitivity label**.
4. Name the policy `Challenge 1 Financial Auto-Label`.
5. Select the target label that best matches sensitive financial content, such as `Confidential \ Finance`.
6. Keep **Full directory** selected unless your tenant requires administrative unit scoping.
7. For locations, include at least **SharePoint sites** and **OneDrive accounts**. If Exchange is available and pre-staged for this challenge, you may include it as well.
8. Add a condition based on a built-in sensitive info type aligned to financial data, such as credit card information, bank account information, or another finance-related sensitive info type available in the tenant.
9. If simulation mode is offered, leave the policy in simulation first so you can review expected matches before full enforcement.
10. Complete the wizard and save the policy.
11. After the policy is created, open it and review the scope, selected label, and rule conditions.
12. If simulation results or activity summaries are already available in the tenant, review them and note the expected labeled locations.

> [!Important]
> Microsoft Learn recommends simulation mode for auto-labeling policies so you can validate likely results before enforcing labeling broadly across SharePoint, OneDrive, and Exchange.

## Task 6: Enable SharePoint and OneDrive support and review evidence

In this task, you will verify that sensitivity labels are usable with SharePoint and OneDrive and review available analytics or activity evidence.

1. In the Microsoft Purview portal, return to **Information Protection** and review the published labels and policies.
2. Confirm with your facilitator notes or pre-staged tenant settings that sensitivity labels are enabled for use with SharePoint and OneDrive files.
3. If your tenant includes the relevant setting workflow, review the configuration that enables sensitivity labels for Office files in SharePoint and OneDrive.
4. Open any available activity, analytics, or policy reporting experience tied to Information Protection in the portal.
5. Review whether you can see evidence such as:
   - Recently created labels
   - Published label policy status
   - Auto-labeling simulation output
   - Label-related activity or analytics
6. If sample files are pre-staged in SharePoint or OneDrive for this challenge, inspect one example location and verify whether sensitivity labeling is available or already applied.
7. Capture at least one screenshot that demonstrates either label availability, policy presence, or analytics/activity evidence.
8. Save your screenshots and notes for use in later challenges, where you will compare protection design with detection and investigation outcomes.

> [!Note]
> In some tenants, propagation delays or licensing constraints can limit what appears immediately in analytics. If live evidence is delayed, document the completed configuration and use screenshots of the label and policy settings as your proof of implementation.

<validation step="Information Protection"/>

## Summary

In this challenge, you established the foundational Microsoft Purview Information Protection configuration for the hackathon. You created a sensitivity label taxonomy with four labels and two Confidential sublabels, applied stronger protection to the most sensitive label, published the labels through a label policy, configured an auto-labeling policy based on sensitive information types, and verified readiness for SharePoint and OneDrive usage. These controls create the baseline for later challenges that focus on DLP, investigations, posture management, and final incident response evidence.