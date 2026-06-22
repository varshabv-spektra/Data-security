# Challenge 2: Data Loss Prevention (DLP)

### Estimated Duration: 1 Hour

## Scenario

Following the recent exposure event, your response team must reduce the ways sensitive business data can leave the organization. In this challenge, you will configure Microsoft Purview Data Loss Prevention controls to protect email, files, collaboration messages, and endpoint activity. Your goal is to create a practical DLP policy set that blocks risky sharing, notifies users, and produces evidence the team can use during investigation.

## Overview

In this challenge, you will sign in to the Microsoft Purview portal, review the existing data security context, and build DLP coverage for Exchange Online, SharePoint Online, OneDrive, Microsoft Teams, and endpoint devices where the tenant has already been prepared. You will also enable notifications and review reporting evidence so the team can confirm the controls are working.

## Objectives

- Task 1: Access the lab environment and review the DLP scope
- Task 2: Create DLP protection for Exchange, SharePoint, and OneDrive
- Task 3: Extend DLP controls to Microsoft Teams and endpoint devices
- Task 4: Review alerts, Activity explorer evidence, and policy outcomes

## Task 1: Access the lab environment and review the DLP scope

In this task, you will sign in to the lab environment and confirm the Microsoft Purview locations that will be included in this challenge.

1. On the lab VM, open Microsoft Edge.
2. Browse to the Microsoft Purview portal at <https://purview.microsoft.com>.
3. Sign in with the following credentials:
   - Username: `<inject key="AzureAdUserEmail"></inject>`
   - Password: `<inject key="AzureAdUserPassword"></inject>`
4. When prompted, complete any first-run or multifactor prompts that are already pre-staged for the lab tenant.
5. In a separate browser tab, open the Azure portal at <https://portal.azure.com> and confirm that your subscription context is available for this deployment:
   - Subscription: `<inject key="SubscriptionID"></inject>`
   - Tenant: `<inject key="TenantID"></inject>`
6. Record your deployment reference for the challenge evidence package as **Deployment ID: `<inject key="DeploymentID" enableCopy="false"></inject>`**.
7. In Microsoft Purview, select **Solutions** from the left navigation, and then open **Data loss prevention**.
8. Review the **Overview** page and note any visible policy sync or device status indicators.
9. Select **Policies** and review whether any starter or previously created policies exist from Challenge 1 or tenant pre-staging.
10. Confirm that the locations relevant to this challenge are available in the environment:
    - Exchange email
    - SharePoint sites
    - OneDrive accounts
    - Teams chat and channel messages
    - Devices

> [!Note]
> Microsoft Learn documents that DLP policies in Microsoft Purview can target Exchange email, SharePoint sites, OneDrive accounts, Teams chat and channel messages, and devices when the tenant and licensing prerequisites are in place.

> [!Important]
> If **Devices** or **Teams chat and channel messages** does not appear as an available location, continue the challenge with the locations that are present and capture a note in your evidence folder that the feature is tenant-prerequisite dependent.

## Task 2: Create DLP protection for Exchange, SharePoint, and OneDrive

In this task, you will create a DLP policy that protects financial data in email and Microsoft 365 files, with special focus on external exposure.

1. In Microsoft Purview, stay in **Data loss prevention** > **Policies**.
2. Select **Create policy**.
3. On the template selection page, choose a policy template aligned to financial data if available, or choose **Custom** if the lab instructions require you to build the policy manually.
4. Name the policy `Hackathon - Financial DLP`.
5. Add a description such as `Protects sensitive financial data across Exchange, SharePoint, OneDrive, and Teams.`
6. On the locations page, turn on these locations:
   - **Exchange email**
   - **SharePoint sites**
   - **OneDrive accounts**
7. If the wizard supports scoping, leave the policy targeted to all users and locations unless the tenant has been pre-scoped for a specific pilot group.
8. Proceed to the rule configuration page.
9. Create or edit a rule that detects sensitive financial content, for example by using one or more financial sensitive information types provided in the template, or by selecting a relevant built-in sensitive information type such as credit card or financial account data when working in a custom policy.
10. Add a condition that focuses on inappropriate sharing, such as content being shared with people outside the organization, when that option is available for Microsoft 365 locations.
11. Configure the Exchange protection behavior so that messages matching the rule and sent externally are blocked or restricted according to the options available in the wizard.
12. Configure the SharePoint and OneDrive protection behavior so that access is restricted for people outside the organization when matching files are shared externally.
13. Under **User notifications**, enable policy tips so users are informed when they trigger the policy.
14. If notification email options are available for Exchange, SharePoint, and OneDrive, enable them for the user and add an administrative contact if required by the wizard.
15. Under alerting or incident reports, enable alert generation for high-severity matches or repeated matches.
16. If the wizard offers **simulation mode**, use it first only if your facilitator instructed you to observe simulated outcomes. Otherwise, enable the policy in active mode to support the hackathon validation window.
17. Review the configuration summary and select **Submit**.
18. Wait for the policy to be created, then return to the **Policies** list and open the new policy.
19. Confirm that Exchange, SharePoint, and OneDrive appear in the applied locations summary.
20. Capture a screenshot of the created policy for your challenge evidence.

> [!Tip]
> Microsoft Learn recommends testing and tuning DLP policies in simulation mode before moving to restrictive enforcement, but for timed hackathon delivery you may be asked to use active enforcement if the tenant has already been prepared for rapid validation.

> [!Note]
> For SharePoint and OneDrive, DLP can block people outside your organization from accessing matching content. For Exchange, DLP can block or warn on messages that contain sensitive information and are being sent externally.

<validation step="DLP policy coverage and expected protective settings/evidence"/>

## Task 3: Extend DLP controls to Microsoft Teams and endpoint devices

In this task, you will expand the DLP configuration to protect collaboration messages and, where the environment is ready, sensitive data on endpoint devices.

1. Return to **Data loss prevention** > **Policies**.
2. Select the `Hackathon - Financial DLP` policy you created, and choose **Edit policy**.
3. Move through the wizard until you reach **Choose locations to apply the policy**.
4. Turn on **Teams chat and channel messages**.
5. Continue to the advanced rule settings.
6. Review the user notification settings and confirm policy tips are enabled.
7. If a custom policy tip message is available, add a short instruction such as `This message may expose regulated financial information. Remove the data or use an approved process.`
8. Save the policy update and submit the changes.
9. Record that Microsoft Learn notes Teams DLP uses message flags and policy tips rather than the email-style notification behavior used in Exchange, SharePoint, and OneDrive.
10. If the lab tenant includes endpoint DLP readiness, create or edit a DLP policy that includes the **Devices** location.
11. In the endpoint-enabled policy, scope the policy to the prepared users or groups if the environment uses a pilot scope.
12. Add a rule that detects the same financial sensitive information type used earlier.
13. Configure at least one endpoint action, based on what is available in the tenant, such as:
    - **Copy to clipboard** = Block or Block with override
    - **Copy to USB removable device** = Block, Warn, or Audit
    - **Print** = Audit or Block
    - **Copy to a network share** = Audit or Block
14. Save and submit the endpoint policy.
15. If endpoint controls are not available in the lab tenant, document in your evidence notes that endpoint DLP requires prepared onboarding and device management prerequisites and continue to the next task.

> [!Important]
> Microsoft Learn states that Teams message protection requires the **Teams chat and channel messages** location in the DLP policy. Protection for files shared through Teams depends on SharePoint and OneDrive because Teams stores shared files in those services.

> [!Note]
> Endpoint DLP enforcement depends on device onboarding and policy scoping. Microsoft Learn states that for endpoint enforcement, both the targeted user and the targeted device must be in scope.

<validation step="DLP policy coverage and expected protective settings/evidence"/>

## Task 4: Review alerts, Activity explorer evidence, and policy outcomes

In this task, you will review the telemetry and reporting views that show whether DLP is detecting and acting on risky activity.

1. In Microsoft Purview, return to **Data loss prevention**.
2. Open the **Overview** page and review summary tiles such as policy sync status, top activities, and device status if available.
3. Open **Activity explorer** from the DLP solution area or the related data classification reporting area.
4. Filter the view to DLP-related activities.
5. Look for events such as:
   - **DLP rule matched**
   - User override activity if enabled
   - Endpoint egress activity if endpoint DLP is configured
6. If seeded activity is available in the tenant, inspect one result and note the matched policy, rule, user, workload, and time.
7. Open the DLP alerts experience if alerts were enabled in your policy.
8. Review whether any incidents or alerts are present for the policy you created or updated.
9. If no live alerts are visible yet, record that Microsoft Learn notes DLP policies generally take about an hour to take effect after being turned on.
10. Save screenshots or notes that show:
    - Policy name and locations
    - Notification or tip configuration
    - Any alert, incident, or Activity explorer evidence
    - Any endpoint evidence or prerequisite gap you observed
11. Store this evidence in the lab VM folder designated by your facilitator for the final incident narrative.

> [!Tip]
> In SharePoint and OneDrive, DLP can evaluate existing and new items. In Exchange, DLP evaluates new email messages but does not retroactively scan older email already stored in a mailbox for alert generation.

> [!Note]
> Activity explorer is one of the primary places to review DLP rule matches and related user activity. For endpoint scenarios, it can show detailed activity such as copy to USB, copy to clipboard, print, or network share actions when devices are onboarded.

<validation step="DLP policy coverage and expected protective settings/evidence"/>

## Summary

In this challenge, you created or updated Microsoft Purview DLP protection for Exchange, SharePoint, OneDrive, Teams, and endpoint devices where applicable. You enabled user-facing notifications, added blocking or restriction logic for risky external sharing, and reviewed the reporting surfaces used to confirm whether the policy is working. These controls now form the operational DLP baseline that the team will rely on during the later investigation and remediation challenges.
