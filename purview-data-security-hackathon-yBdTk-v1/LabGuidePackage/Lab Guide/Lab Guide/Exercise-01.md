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
2. Open Microsoft Edge, browse to
 `
 https://portal.azure.com
 `
and sign in with:
   - Username: <inject key="AzureAdUserEmail"></inject>

      ![](media/p1i2.png)

   - Password: <inject key="AzureAdUserPassword"></inject>

      ![](media/p1i3.png)
3. After Azure sign-in completes, open a new tab and browse to
   `
   https://purview.microsoft.com
   `
4. If prompted to select a tenant or account, confirm that you are working in the tenant associated with:
   - Tenant ID: <inject key="TenantID"></inject>
   - Subscription ID: <inject key="SubscriptionID"></inject>
5. Record your deployment reference for screenshots and evidence collection as **Deployment ID: <inject key="DeploymentID" enableCopy="false"></inject>**.
6. In the Microsoft Purview portal, select **Solutions (1)** > **Information Protection (2)**.

   ![](media/p2t1s6.png)

7. Spend a minute reviewing the left navigation so you can identify these areas used later in the challenge:
   - **Sensitivity labels (1)**
   - **Policies** > **Label publishing policies (2)** > **Auto-labeling policies (3)**

      ![](media/p2t1s7.png)

> [!Tip]
> Save screenshots in your evidence folder using filenames that include your deployment identifier so they can be correlated later during the investigation and remediation summary.

## Task 2: Create the sensitivity label taxonomy

In this task, you will create a label taxonomy with four labels and two sublabels under Confidential.

1. In the Microsoft Purview portal, go to **Solutions (1)** > **Information Protection (2)** > **Sensitivity labels (3)**.
   ![](media/p2t1s6.png)

   ![](media/p2t2s1.png)

2. Select **+ Create a label**.

   ![](media/p2t2s2.png)

3. Create the first label with the following values:
   - **Name**: `Public (1)`
   - **Display name**: `Public (2)`
   - **Description for users**: `Use for information approved for broad internal and external sharing. (3)`
   - Click **Next (4)**.

      ![](media/p2t2s3.png)

4. For scope, keep the label available for **Files & other data assets (1)** and **Emails (2)**, Click **Next (3)**.

   ![](media/p2t2s4.png)

   Continue through the wizard and leave advanced protection settings off for this label unless your tenant already applies defaults.

5. Review the sensitivity label settings, verify the label details and scope, and then select **Create label** to create the **Public** sensitivity label.
   ![](media/p2t2s4.0.png)

6. Verify that the sensitivity label was created successfully, then click **Done** to return to the **Sensitivity labels** page.

   ![](media/p2t2s4.1.png)

7. Click **Cancel** to return to the **Sensitivity labels** page.

8. Select **+ Create a label**.

   ![](media/p2t2s5.png)
5. Create the second label with the following values:
   
   - **Name**: `General (1)`
   - **Display name**: `General (2)`
   - **Description for users**: `Use for standard business information intended for routine internal use. (3)`
   - Click **Next (4)**.

      ![](media/p2t2s5.0.png)

6. For scope, keep the label available for **Files & other data assets (1)** and **Emails (2)**, Click **Next (3)**.

   ![](media/p2t2s5.1.png)

7. Review the sensitivity label settings, verify the label details and scope, and then select **Create label** to create the **Public** sensitivity label.
   ![](media/p2t2s5.2.png)

6. Verify that the sensitivity label was created successfully, then click **Done** to return to the **Sensitivity labels** page.

   ![](media/p2t2s5.3.png)

7. Click **Cancel** to return to the **Sensitivity labels** page.

8. Select **+ Create a label**.

   ![](media/p2t2s6.png)

5. Create the third label with the following values:
   
   - **Name**: `Confidential (1)`
   - **Display name**: `Confidential (2)`
   - **Description for users**: `Use for sensitive business information that requires controlled access. (3)`
   - Click **Next (4)**.

      ![](media/p2t2s6.0.png)

6. For scope, keep the label available for **Files & other data assets (1)** and **Emails (2)**, Click **Next (3)**.

   ![](media/p2t2s6.1.png)

7. Review the sensitivity label settings, verify the label details and scope, and then select **Create label** to create the **Public** sensitivity label.
   ![](media/p2t2s6.2.png)

6. Verify that the sensitivity label was created successfully, then click **Done** to return to the **Sensitivity labels** page.

   ![](media/p2t2s6.3.png)

7. Click **Cancel** to return to the **Sensitivity labels** page.

7. Select the **Confidential (1)** label, and choose **Create sublabel (2)**.

   ![](media/p2t2s7.0.png)

8. Create the first sublabel with values similar to the following:
   - **Name**: `Finance (1)`
   - **Display name**: `Finance (2)`
   - **Description for users**: `Use for sensitive financial and payment-related content. (3)`

      ![](media/p2t2s8.png)

6. For scope, keep the label available for **Files & other data assets (1)** and **Emails (2)**, Click **Next (3)**.

      ![](media/p2t2s8.0.png)

7. Review the sensitivity label settings, verify the label details and scope, and then select **Create label** to create the **Public** sensitivity label.
   ![](media/p2t2s8.1.png)

6. Verify that the sensitivity label was created successfully, then click **Done** to return to the **Sensitivity labels** page.

   ![](media/p2t2s8.2.png)

7. Click **Cancel** to return to the **Sensitivity labels** page.

8. Select the **Confidential (1)** label, and choose **Create sublabel (2)**

   ![](media/p2t2s9.png)

9. Create a second sublabel under **Confidential** with values similar to the following:
   - **Name**: `Legal (1)`
   - **Display name**: `Legal (2)`
   - **Description for users**: `Use for contracts, legal advice, and privileged legal content. (3)`

      ![](media/p2t2s9.0.png)

6. For scope, keep the label available for **Files & other data assets (1)** and **Emails (2)**, Click **Next (3)**.

      ![](media/p2t2s9.1.png)

7. Review the sensitivity label settings, verify the label details and scope, and then select **Create label** to create the **Public** sensitivity label.
   ![](media/p2t2s9.2.png)

6. Verify that the sensitivity label was created successfully, then click **Done** to return to the **Sensitivity labels** page.

   ![](media/p2t2s9.3.png)

7. Click **Cancel** to return to the **Sensitivity labels** page.

8. Select **+ Create a label**.

   ![](media/p2t2s10.png)

10. Create a fourth top-level label
   
      - **Name**: `Highly Confidential (1)`
      - **Display name**: `Highly Confidential (2)`
      - **Description for users**: `Use for highly sensitive information, including strategic, executive, regulated, or restricted content that requires the highest level of protection. (3)`
      - Click **Next (4)**.

         ![](media/p2t2s10.0.png)

11. When configuring **Highly Confidential**, make sure the label scope includes **Files & other data assets** and **Emails**.

      ![](media/p2t2s10.1.png)

7. Review the sensitivity label settings, verify the label details and scope, and then select **Create label** to create the **Public** sensitivity label.
   ![](media/p2t2s10.2.png)

6. Verify that the sensitivity label was created successfully, then click **Done** to return to the **Sensitivity labels** page.

   ![](media/p2t2s10.3.png)

7. Click **Cancel** to return to the **Sensitivity labels** page.

12. Finish the label creation wizard and return to the **Sensitivity labels** page.

      ![](media/p2t2s12.png)

> [!Important]
> Microsoft Learn guidance notes that sublabels are created from the parent label's action menu rather than as standalone top-level labels. Be sure both Confidential sublabels are nested under the Confidential parent.

## Task 3: Label Priority

In this task, you will configure the most restrictive label to protect content with encryption and ensure label order reflects increasing sensitivity.

1. Return to the **Sensitivity labels** list and review the label order.

8. Reorder the labels so that the least restrictive label is at the top and the most restrictive label is at the bottom. A recommended final order is:
   - `Public`
   - `General`
   - `Confidential`
   - `Highly Confidential`

      ![](media/p2t3s7.png)

9. Confirm that the `Confidential / Finance` and `Confidential / Legal` sublabels remain grouped under the parent label.

   ![](media/p2t3s8.png)

> [!Note]
> Microsoft Learn states that label priority matters. In the Purview list, the most restrictive label should appear lower in the list, while less restrictive labels should appear higher.

<validation step="Information Protection"/>

## Task 4: Publish the labels to users

In this task, you will publish the labels through a label policy so users and services can consume them.

1. In **Information Protection (1)**, open **Label publishing policies (2)** from the drop-down menu of **Policies**.

   ![](media/p2t4s1.png)

1. Select **Publish label**.

   ![](media/p2t4s2.png)

2. Select **Choose sensitivity labels to publish (1)**.

4. When prompted to choose labels to publish, include all of the labels created in this challenge and click **Add (3)**.
   - `Public`
   - `General`
   - `Confidential`
   - `Confidential / Finance`
   - `Confidential / Legal`
   - `Highly Confidential`

   ![](media/p2t4s3.png)

1. Review the list of sensitivity labels to be published, verify that **Public**, **General**, **Confidential**, **Confidential/Finance**, **Confidential/Legal**, and **Highly Confidential** are included, and then click **Next**.

   ![](media/p2t4s3.0.png)

6. Continue through the policy settings and review any relevant options for default labeling, mandatory labeling, or policy tips if they are already enabled in the tenant design.

3. In the **Name** field, enter **Challenge 1 Label Policy (1)**, and then click **Next (2)**.

   ![](media/p2t4s5.png)

2. Review the policy configuration, verify that all required sensitivity labels are listed and the policy name is **Challenge 1 Label Policy**, and then click **Submit** to create the publishing policy.

   ![](media/p2t4s5.0.png)

3. Verify that the publishing policy was created successfully, review the confirmation message, and then click **Done** to return to the **Publishing policies** page.

   ![](media/p2t4s5.1.png)

8. Return to the **Label policies** page and verify that `Challenge 1 Label Policy` appears in the list.

   ![](media/p2t4s7.png)

9. Open the policy and review that the selected labels are included.

> [!Tip]
> Publishing a label policy makes the labels available to assigned users and services. It can take time for policy replication to complete across Microsoft 365 workloads.

## Task 5: Create an auto-labeling policy

In this task, you will create an auto-labeling policy that applies a sensitivity label when sensitive information is detected.

1. In the Microsoft Purview portal, go to **Solutions** > **Information Protection** > **Policies** > **Auto-labeling policies**.

   ![](media/p2t5s1.png)

2. Select **+ Create auto-labeling policy**.

   ![](media/p2t5s2.png)

3. Choose the option to **Automatically apply labels only**.

   ![](media/p2t5s3.png)

4. Name the policy `Challenge 1 Financial Auto-Label (1)` and click **Next (2)**.

   ![](media/p2t5s3.0.png)

5. Click **Choose a label (1)**, select **Confidential/Finance (2)** from the list of available sensitivity labels, and then click **Add (3)**.

   ![](media/p2t5s3.1.png)

2. Verify that **Confidential/Finance** appears as the selected label to auto-apply, and then click **Next**.

   ![](media/p2t5s3.2.png)

3. For locations, include at least **SharePoint sites (2)** and **OneDrive accounts (3)**. If **Exchange mail (1)** is available and pre-staged for this challenge, you may include it as well.Then click **Next (4)**.

   ![](media/p2t5s3.3.png)

4. In the **Name (1)** field, enter **Financial Data Detection**, click **Add condition (2)**, and then select **Content contains (3)** to create a condition that detects sensitive financial information

   ![](media/p2t5s3.4.png)

5. Under **Content contains**, click **Add (1)** and select **Sensitive info types (2)** to configure the rule to detect sensitive financial information.

   ![](media/p2t5s3.5.png)


6. In the **Sensitive info types** pane, select **Credit Card Number (1)**, and then click **Add (2)**.

   ![](media/p2t5s3.6.png)

   > **Note:** If additional financial sensitive information types such as **Bank Account Number** or **Credit Card Information** are not available in your tenant, select **Credit Card Number** and continue with the lab.

7. Review the configured condition to confirm that **Credit Card Number** has been added as the sensitive information type, and then click **Save** to create the rule.

   ![](media/p2t5s3.7.png)

8. Review the **Financial Data Detection** rule and verify that **Credit Card Number** is listed as the sensitive information type. Ensure the rule is enabled, and then click **Next** to continue to the policy configuration settings.

   ![](media/p2t5s3.8.png)

9. Review the auto-labeling policy settings, verify that **Confidential/Finance** is selected as the label, **Credit Card Number** is configured as the sensitive information type, and **Simulation** mode is enabled. Then click **Create policy**.

   ![](media/p2t5s3.9.png)

> [!Important]
> Microsoft Learn recommends simulation mode for auto-labeling policies so you can validate likely results before enforcing labeling broadly across SharePoint, OneDrive, and Exchange.

## Task 6: Enable SharePoint and OneDrive support and review evidence

In this task, you will verify that sensitivity labels are usable with SharePoint and OneDrive and review available analytics or activity evidence.

1. In the Microsoft Purview portal, select **Information Protection (1)** from the left navigation pane, select **Sensitivity labels (2)** to view the available sensitivity labels configured in the tenant.

1. Review the available sensitivity labels, including **Public**, **General**, **Confidential**, and **Highly Confidential (3)**, and verify that they are available for classifying and protecting organizational data.


   ![](media/p2t6s1.0.png)

1. In **Information Protection**, expand **Policies (1)** and select **Label publishing policies (2)** to review the sensitivity label publishing policies configured in the tenant, Review the list of available publishing policies and verify that **Challenge 1 Label Policy (3)** is present.

   ![](media/p2t6s1.1.png)

1. In **Information Protection**, select **Sensitivity labels (1)** to review the available labels configured in the tenant, Select the **Personal (2)** sensitivity label to open and review its configuration details.

1. In the details pane, verify that the **Scope** includes **Files & other data assets, Email, Meetings**, confirming that the label can be applied across multiple Microsoft 365 content types.

   ![](media/p2t6s1.2.png)

1. In **Information Protection**, expand **Explorers (1)** and select **Activity explorer (2)** to review activities related to sensitivity labels, DLP events, and protected content, Review the **Activity explorer** page and note the message indicating that auditing must be enabled before activity data can be collected and displayed.

   ![](media/p2t6s1.3.png)

1. In **Information Protection**, expand **Policies (1)** and select **Auto-labeling policies (2)** to review the automatically applied sensitivity labeling policies configured in the tenant, Review the list of available auto-labeling policies and verify that **Challenge 1 Financial Auto-Label (3)** is present.

   ![](media/p2t6s1.4.png)

1. Confirm that the policy is configured in **Simulation** mode and is configured to apply the **Confidential/Finance** sensitivity label across **Exchange**, **SharePoint**, and **OneDrive** locations.

> [!Note]
> In some tenants, propagation delays or licensing constraints can limit what appears immediately in analytics. If live evidence is delayed, document the completed configuration and use screenshots of the label and policy settings as your proof of implementation.

<validation step="Information Protection"/>

## Summary

In this challenge, you established the foundational Microsoft Purview Information Protection configuration for the hackathon. You created a sensitivity label taxonomy with four labels and two Confidential sublabels, applied stronger protection to the most sensitive label, published the labels through a label policy, configured an auto-labeling policy based on sensitive information types, and verified readiness for SharePoint and OneDrive usage. These controls create the baseline for later challenges that focus on DLP, investigations, posture management, and final incident response evidence.