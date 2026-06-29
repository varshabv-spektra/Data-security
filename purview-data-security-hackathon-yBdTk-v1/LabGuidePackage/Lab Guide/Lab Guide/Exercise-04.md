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

1. On the lab VM, open Microsoft Edge.
2. Browse to the Microsoft Purview portal at 
`
https://purview.microsoft.com
`
3. Sign in with the following credentials:
   - Username: <inject key="AzureAdUserEmail"></inject>

      ![](media/p1i2.png)

   - Password: <inject key="AzureAdUserPassword"></inject>

      ![](media/p1i3.png)

4. When prompted, complete any first-run or multifactor prompts that are already pre-staged for the lab tenant.
5. In a separate browser tab, open the Azure portal at 
`
https://portal.azure.com
`
 and confirm that your subscription context is available for this deployment:
   - Subscription: <inject key="SubscriptionID"></inject>
   - Tenant: <inject key="TenantID"></inject>
   
4. In the left navigation pane, select **Solutions (1)**.
5. Open **DSPM (2)**.

   ![](media/p5t1s4.png)

1. Click **Get started** to begin the DSPM setup and continue with the configuration process.

   ![](media/p5t1s4.0.png)

1. On the **Complete setup to unlock the unified DSPM experience** page, review the setup options for **Auditing and analytics** and **Collection policies for AI**, Click **Start setup** to begin configuring the unified DSPM experience and enable the recommended data security insights and collection policies.

   ![](media/p5t1s4.1.png)

1. Click **Close** to exit the setup completion page and return to the Microsoft Purview portal.

   ![](media/p5t1s4.2.png)

1. In the **DSPM** portal, verify that **Posture (1)** is selected from the left navigation pane, In the **Top objectives to protect sensitive data (2)** section, review the available data protection objectives and security recommendations.

   ![](media/p5t1s4.3.png)

1. On the **DSPM > Posture** page, review the current posture summary and the **Top objectives to protect sensitive data** section, Identify the visible objective **Prevent oversharing of sensitive data (1)** and review the available remediation options, including **View remediation plan** and **View objective**, Scroll down to the **Data snapshot (2)** section and review the available posture insights for stale and fresh data, including any visible data exposure, labeling status, and exfiltration metrics

   ![](media/p5t1s4.4.png)

1. In the **DSPM** portal, select **Objectives** from the left navigation pane to review the organization's data security objectives and recommendations.

   ![](media/p5t1s4.5.png)

1. Review the visible DSPM objectives and identify the current top objectives, including:
    - **Prevent oversharing of sensitive data**
    - **Prevent exfiltration to risky destinations**
    - **Discover unmonitored data sources referenced by AI apps**

      ![](media/p5t1s4.6.png)

> [!Tip]
> If sample data is limited in the tenant, focus on the visible workflow areas Microsoft documents for DSPM: **Posture**, **Objectives**, **AI observability**, **Activity explorer**, **Data risk assessments**, and **Remediation actions**.

## Task 2: Inspect AI-related recommendations and document a remediation action

In this task, you will review AI-related recommendations and identify one action the team can take to reduce exposure.

1. In the Microsoft Purview portal, click **Solutions (1)** from the left navigation pane to open the list of available solutions, select **DSPM (2)** to open **Data Security Posture Management** and review security posture insights, protection objectives, and data risk recommendations for the organization.

   ![](media/p5t2s1.png)

1. In **DSPM**, select **Objectives** from the left navigation pane to review the organization's data security objectives, Review the visible objectives and identify the available data protection goals, including **Prevent data exposure in Microsoft 365 Copilot and Microsoft Copilot interactions** and **Prevent oversharing of sensitive data**.

1. Review the objective details, including the current interaction statistics, risk indicators, and available remediation actions such as **View remediation plan** and **View objective**.

   ![](media/p5t2s1.0.png)

1. In **DSPM**, select **AI observability (1)** from the left navigation pane to review AI applications, agents, and related risk insights across the organization, Verify that the **All apps & agents (2)** tab is selected to display the complete inventory of discovered AI applications and agents, 
Review the available AI applications and agents listed in the inventory, including their **Status**, **Agent ID**, **Risk level**, **Risk types**, and **Sensitive activity trend (3)** information.

   ![](media/p5t2s1.1.png)

1. In **DSPM**, expand **Discover (1)** and select **Activity explorer (2)** to review activities related to sensitive information, sensitivity labels, and data protection events.

1. Review the available filters, including **Creation Time**, **Activity**, **Workload**, **Sensitive Info Types**, and **Sensitivity Labels**, which can be used to investigate data security activities

   ![](media/p5t2s1.2.png)

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

1. In the Microsoft Purview portal, click **Solutions (1)** from the left navigation pane, select **Information Barriers (2)** to open the Information Barriers solution and begin configuring information barrier policies.

   ![](media/p5t3s1.png)

2. In **Information Barriers**, select **Segments (1)** from the left navigation pane, click **+ New segment (2)** to create a new segment for Information Barriers policy configuration.

   ![](media/p5t3s2.png)

3. On the **Provide a segment name** page, enter **Finance-Segment (1)** in the **Name** field, Click **Next (2)** to proceed to the **User group filter** configuration step.

   ![](media/p5t3s3.png)

1. On the **User group filter** page, click **Add (1)** to add an attribute that will be used to define the segment, From the list of available attributes, select **Department (2)** as the user attribute for the Finance segment.

   ![](media/p5t3s3.0.png)

1. On the **Add user group filter** page, enter **Finance (1)** as the value for the **Department** attribute,  Verify that the filter condition is set to **Equal** and the department value is **Finance**, Click **Next (2)** to proceed to the **Review your settings** page

   ![](media/p5t3s3.1.png)

1. On the **Review your settings** page, verify that the segment name is **Finance-Segment** and that the user group filter is configured as **department -eq 'Finance'**, Click **Submit** to create the **Finance-Segment** Information Barrier segment.

   ![](media/p5t3s3.2.png)

1. Verify that the **Segment created** confirmation message is displayed, indicating that the **Finance-Segment** Information Barrier segment was created successfully, Click **Done (1)** to return to the **Segments** page and view the newly created segment.

   ![](media/p5t3s3.3.png)

1. In the Microsoft Purview portal, click **Solutions (1)** from the left navigation pane, select **Information Barriers (2)** to return to the Information Barriers solution and continue the configuration tasks.

   ![](media/p5t3s3.4.png)

1. In **Information Barriers**, verify that **Segments (1)** is selected and review the list of available segments, Click **+ New segment (2)** to create another segment.

   ![](media/p5t3s3.5.png)

1. On the **Provide a segment name** page, enter **Research-Segment (1)** in the **Name** field, Click **Next (2)** to proceed to the **User group filter** configuration step for the Research segment.

   ![](media/p5t3s3.6.png)

1. On the **User group filter** page, click **Add (1)** to add a user attribute for the Research segment, From the list of available attributes, select **Department (2)** as the filter attribute for defining members of the Research segment.

   ![](media/p5t3s3.7.png)

1. On the **Add user group filter** page, enter **Research (1)** as the value for the **Department** attribute, Click **Next (2)** to proceed to the **Review your settings** page.

   ![](media/p5t3s3.8.png)

1. On the **Review your settings** page, verify that the segment name is **Research-Segment** and that the user group filter is configured as **department -eq 'Research'**, Click **Submit (3)** to create the **Research-Segment** Information Barrier segment.

   ![](media/p5t3s3.9.png)

1. Verify that the **Segment created** confirmation message is displayed, indicating that the **Research-Segment** Information Barrier segment was created successfully, Click **Done** to return to the **Segments** page and view the newly created **Research-Segment**.

   ![](media/p5t3s3.10.png)

1. On the **Segments** page, verify that both **Research-Segment** and **Finance-Segment** are listed, confirming that the Information Barrier segments were created successfully.

   ![](media/p5t3s3.11.png)

> [!Important]
> The exact filter options available can vary by tenant configuration. If the tenant already contains pre-created groups for the hackathon personas, use those groups so your Information Barriers design aligns to the seeded scenario.

## Task 4: Create and apply an Information Barriers policy

In this task, you will create a policy that blocks communication between the two segments.

1. In **Information Barriers (1)**, expand **Policies (2)** and select **Policies (3)** from the left navigation pane.

   ![](media/p5t4s1.png)

1. On the **Policies** page, click **+ Create policy** to create a new Information Barrier policy.

   ![](media/p5t4s2.png)

1. On the **Provide a policy name** page, enter **Finance-Research-Block (1)** in the **Name** field, Click **Next (2)** to continue to the **Assigned segment** configuration step.

   ![](media/p5t4s2.0.png)

1. On the **Add assigned segment details** page, click **Choose segment (1)** to select the segment that the policy will apply to, In the **Select assigned segment for this policy** pane, select **Finance-Segment (2)**, Click **Add (3)** to assign the **Finance-Segment** to the **Finance-Research-Block** Information Barrier policy.

   ![](media/p5t4s2.1.png)

1. Verify that **Finance-Segment (1)** is selected as the assigned segment for the policy, Click **Next (2)** to proceed to the **Communication and collaboration** configuration page.

   ![](media/p5t4s2.2.png)

1. On the **Configure communication and collaboration details** page, set **Communication and collaboration (1)** to **Blocked** to prevent communication between the selected segments.

   ![](media/p5t4s2.3.png)

1. On the **Configure communication and collaboration details** page, click **Choose segment (1)** to select the segment that will be blocked from communicating with the assigned segment, In the **Select segments to allow or block** pane, select **Research-Segment (2)**, Click **Add (3)** to add the selected segment to the blocked communications list, After confirming the segment selection, click **Next (4)** to proceed to the **Policy status** configuration page.

   ![](media/p5t4s2.3.1.png)

1. On the **Configure policy status** page, verify that the policy status toggle is set to **On (1)** so that the Information Barrier policy will be activated after deployment, Click **Next (2)** to proceed to the **Review your settings** page.

   ![](media/p5t4s2.4.png)

1. On the **Review your settings** page, verify the policy configuration, including:
   - **Name:** Finance-Research-Block
   - **Assigned segment:** Finance-Segment
   - **Blocked segments:** Research-Segment
   - **Policy status:** Active

   Click **Submit** to create and activate the **Finance-Research-Block** Information Barrier policy.

   ![](media/p5t4s2.5.png)

1. Verify that the **Policy created** confirmation message is displayed, indicating that the **Finance-Research-Block** Information Barrier policy was created successfully, Click **Done** to return to the **Policies** page and view the newly created Information Barrier policy.

   ![](media/p5t4s2.6.png)

1. If your environment requires reciprocal blocking for clear two-way enforcement, create a second block policy in the opposite direction.

1. On the **Policies** page, click **+ Create policy** to start creating a new Information Barrier policy that controls communication and collaboration between specific user segments.

   ![](media/p5t4s2.8.png)

1. On the **Provide a policy name** page, enter **Research-Finance-Block (1)** in the **Name** field to create a policy that restricts communication between the Research and Finance segments, Click **Next (2)** to proceed to the **Assigned segment** configuration page.

   ![](media/p5t4s2.9.png)

1. On the **Add assigned segment details** page, click **Choose segment (1)** to select the segment that the policy will be assigned to, In the **Select assigned segment for this policy** pane, select **Research-Segment (2)**, Click **Add (3)** to assign the **Research-Segment** to the **Research-Finance-Block** policy.

   ![](media/p5t4s2.10.png)

1. After confirming that **Research-Segment** is selected as the assigned segment, click **Next** to continue to the **Communication and collaboration** configuration page.

   ![](media/p5t4s2.11.png)

1. On the **Configure communication and collaboration details** page, set **Communication and collaboration** to **Blocked** to restrict communication and collaboration between the assigned segment and the selected segment

   ![](media/p5t4s2.12.png)

1. On the **Configure communication and collaboration details** page, click **Choose segment (1)** to select the segment that will be blocked from communicating with the assigned segment, In the **Select segments to allow or block** pane, select **Finance-Segment (2)**, Click **Add (3)** to add **Finance-Segment** to the blocked segments list, Verify that **Research-Segment** and **Finance-Segment** are configured as blocked segments, and then click **Next (4)** to proceed to the **Policy status** configuration page.

   ![](media/p5t4s2.13.png)

1. On the **Configure policy status** page, verify that the policy status toggle is set to **On (1)** so that the **Research-Finance-Block** Information Barrier policy will be activated after creation, Click **Next (2)** to proceed to the **Review your settings** page.

   ![](media/p5t4s2.14.png)

1. On the **Review your settings** page, verify the policy configuration, including:
   - **Name:** Research-Finance-Block
   - **Assigned segment:** Research-Segment
   - **Blocked segments:** Finance-Segment
   - **Policy status:** Active

   Click **Submit** to create and activate the **Research-Finance-Block** Information Barrier policy.

   ![](media/p5t4s2.15.png)

1. Verify that the **Policy created** confirmation message is displayed, indicating that the **Research-Finance-Block** Information Barrier policy was created successfully, Click **Done** to return to the **Policies** page and view the newly created **Research-Finance-Block** policy.

   ![](media/p5t4s2.16.png)

1. On the **Policies** page, verify that both Information Barrier policies are listed:
   - **Research-Finance-Block (1)**
   - **Finance-Research-Block (2)**

   Confirm that the **Status** of both policies is **Active**, indicating that communication restrictions between the Finance and Research segments have been successfully applied.

   ![](media/p5t4s2.17.png)

1. In **Information Barriers (1)**, expand **Policies (2)** from the left navigation pane, Select **Policy applications (3)** to review the application status of Information Barrier policies and monitor policy deployment across supported workloads.

   ![](media/p5t4s2.18.png)

1. On the **Policy application** page, click **Apply all policies** to start applying all active Information Barrier policies across supported Microsoft 365 workloads.

   ![](media/p5t4s2.19.png)

1. Monitor the **Status** and **Progress** columns to track the policy application process.

   ![](media/p5t4s2.20.png)

   > **Note:** If no application jobs are displayed immediately, click **Refresh** after initiating the policy application. Policy deployment may take some time to complete across the environment.

> [!Note]
> Microsoft Learn notes that policy evaluation and application can take time, and large tenants may take several hours to fully process. In this hackathon, capture the submitted policy plus the policy application status as your primary evidence if full propagation is not immediate.

## Task 5: Verify enforcement and capture evidence

In this task, you will confirm that the Information Barriers configuration is in place and prepare your incident-hardening evidence.

1. In **Information Barriers (1)**, expand **Policies (2)** and select **Policies (3)** from the left navigation pane.

1. Review the list of Information Barrier policies and verify that both **Research-Finance-Block** and **Finance-Research-Block (4)** are displayed.

1.  Confirm that the **Status** for both policies is **Active**, indicating that the communication restrictions between the Research and Finance segments have been successfully deployed.

      ![](media/p5t5s1.png)

1. In **Information Barriers**, select **Policy applications** from the left navigation pane.

1. Review the policy application job and verify that the **Status** is **Completed**, indicating that the Information Barrier policies have been successfully applied across the environment.

   ![](media/p5t5s3.png)

## Summary

In this challenge, you reviewed Microsoft Purview DSPM posture data, investigated AI-related exposure insights and recommendations, documented a remediation action, and implemented Information Barriers segmentation with a blocking policy. These actions strengthen the organization's posture by combining visibility into data risk with a concrete collaboration control that helps prevent future oversharing between sensitive groups.
