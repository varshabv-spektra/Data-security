# Exercise 05: Challenge 5 — Compliance Foundations

### Estimated Duration: 1 Hour

## Scenario

After implementing labels, DLP controls, and initial investigative workflows, the response team now needs to establish durable compliance foundations for the tenant. In this challenge, you validate audit readiness, configure supervision controls for risky communications, apply retention and records controls for critical business data, and create an eDiscovery workspace that preserves evidence for follow-up investigation.

## Overview

In this challenge, you will work in Microsoft Purview to confirm the organization can retain, search, supervise, and investigate regulated content. You will use Audit, Communication Compliance, Data Lifecycle Management, Records Management, eDiscovery, and Compliance Manager experiences to create a defensible compliance baseline that supports both day-to-day governance and post-incident response.

## Objectives

- Task 1: Sign in and validate audit readiness
- Task 2: Run an audit search for recent compliance activity
- Task 3: Create a Communication Compliance policy
- Task 4: Create retention and records coverage
- Task 5: Create an eDiscovery case with custodian, hold, and content search
- Task 6: Review the file plan and Compliance Manager improvement actions

## Task 1: Sign in and validate audit readiness

In this task, you will sign in to the tenant and confirm that the core compliance investigation surfaces are available.

1. From the lab VM, open Microsoft Edge and browse to the Microsoft Purview portal at <https://purview.microsoft.com>.
2. Sign in with the following credentials:
   - Username: `<inject key="AzureAdUserEmail"></inject>`
   - Password: `<inject key="AzureAdUserPassword"></inject>`
3. If prompted to stay signed in, select **Yes**.
4. In a separate tab, open the Azure portal at <https://portal.azure.com> and sign in with the same account.
5. In the Azure portal, confirm you can access the lab subscription `<inject key="SubscriptionID"></inject>` in tenant `<inject key="TenantID"></inject>`.
6. Return to the Microsoft Purview portal and review the left navigation pane. Confirm that you can see or reach the following solution areas from **Solutions** or the navigation menu:
   - **Audit**
   - **Communication Compliance**
   - **Data lifecycle management**
   - **Records management**
   - **eDiscovery**
   - **Compliance Manager**
7. Record the deployment reference for your notes as **Deployment ID: `<inject key="DeploymentID" enableCopy="false"></inject>`**.
8. Create a plain-text evidence note on the desktop or in your challenge notes listing which Purview solutions are visible and which appear pre-staged by the tenant team.

> [!Important]
> Some Purview experiences depend on licensing, role groups, and pre-enabled prerequisites. If a feature is visible but opens in read-only mode, continue with observation and evidence capture rather than blocking your progress.

## Task 2: Run an audit search for recent compliance activity

In this task, you will use Microsoft Purview Audit to confirm that searchable activity exists for the tenant.

1. In Microsoft Purview, open **Solutions** > **Audit**.
2. If the page prompts you to start recording user and admin activity, note the prompt for your evidence and continue only if the tenant is already configured for the challenge.
3. Select **Search** or **New search**, depending on the portal experience currently shown.
4. Configure the search with these settings:
   - **Date and time range**: Last 7 days
   - **Activities**: Select a few relevant activities such as file accessed, file modified, sensitivity label activities, DLP activities, or mailbox-related activity if available
   - **Users**: Include the seeded incident user or leave blank to search broadly if the scenario account list is pre-staged
5. Run the search and wait for results to load.
6. Open one event from the results and review the detailed properties such as workload, user, activity, item name, or source IP if available.
7. Capture evidence showing that audit events are searchable.
8. In your notes, answer these questions:
   - Which workload produced the most useful results?
   - Which event would help you support a later investigation or legal hold decision?
   - Which activities appear related to the earlier oversharing or risky behavior scenario?

> [!Tip]
> Audit results can take time to appear. If the tenant has pre-seeded evidence, prioritize reviewing existing entries rather than waiting for new activity to ingest.

## Task 3: Create a Communication Compliance policy

In this task, you will create a policy that helps detect inappropriate or risky communications relevant to the post-incident environment.

1. In Microsoft Purview, open **Solutions** > **Communication Compliance**.
2. Review any prerequisite or onboarding banner. If the tenant is already configured, continue to policy creation.
3. Select **Policies** and then choose **Create policy**.
4. Use a template that best fits the challenge goal, such as **Detect inappropriate text**, **Regulatory compliance**, or another available supervised-communications template.
5. Name the policy `Hackathon-CommPolicy-<inject key="DeploymentID"></inject>`.
6. For users or groups in scope, select the pre-staged test users or a scoped group provided in the tenant. If no dedicated group is available, document the limitation and use the smallest suitable test population.
7. Choose one or more supported communication locations, such as:
   - Microsoft Teams chats and channels
   - Exchange email
   - Copilot interactions, if the tenant experience exposes that option
8. Keep default classifiers, trainable classifiers, or conditions unless the facilitator has provided alternate scenario instructions.
9. Configure reviewers if prompted. Use the signed-in account or the pre-assigned compliance reviewer account.
10. Finish the wizard and review the created policy summary page.
11. Record in your notes what the policy is intended to detect, who is in scope, and which communication channels are covered.

> [!Note]
> Communication Compliance templates and exact wizard pages can vary by tenant features and licensing. The important outcome for this challenge is to create or review a policy configuration that supervises regulated or risky communications.

## Task 4: Create retention and records coverage

In this task, you will create baseline retention protection and a records-oriented label for important business content.

1. In Microsoft Purview, open **Solutions** > **Data lifecycle management**.
2. Go to **Policies** and select **Retention policies**.
3. Select **New retention policy**.
4. Configure a baseline retention policy with settings similar to the following:
   - **Name**: `Hackathon-BaselineRetention-<inject key="DeploymentID"></inject>`
   - **Locations**: Choose a small set of relevant workloads such as SharePoint sites, OneDrive accounts, Exchange mailboxes, or Teams messages based on what is available in the lab tenant
   - **Retention settings**: Retain content for a reasonable investigation-support period such as 3 years, then optionally delete based on your organization policy guidance
5. Complete the wizard and review the policy summary.
6. Next, open **Solutions** > **Records management**.
7. Open **File plan** or **Retention labels**, depending on the navigation layout.
8. Create a new retention label with settings similar to the following:
   - **Name**: `Investigation Record - 7 Years - <inject key="DeploymentID"></inject>`
   - **Retention period**: 7 years
   - **Disposition**: Trigger a disposition review before deletion if the option is available
   - **Declare as a record**: Enable if the tenant experience supports this for the chosen label path
9. Publish the label by creating a label policy or adding it to an existing challenge-specific publication policy.
10. Scope the publication to an appropriate workload, such as SharePoint and OneDrive, where incident evidence documents are likely to be stored.
11. If auto-apply is available and tenant prerequisites exist, review the option but keep the scope simple unless instructed otherwise.
12. Save your changes and document the purpose of the baseline retention policy and the records label.

> [!Important]
> Retention policies provide broad lifecycle coverage, while retention labels provide item-level control and can support records declaration and disposition review. Use both concepts intentionally in your narrative.

## Task 5: Create an eDiscovery case with custodian, hold, and content search

In this task, you will create an investigation workspace that can preserve and search for incident-related content.

1. In Microsoft Purview, open **Solutions** > **eDiscovery**.
2. Select **Cases** and then choose **Create case**.
3. Create a case with these values:
   - **Case name**: `Hackathon-Exposure-Investigation-<inject key="DeploymentID"></inject>`
   - **Description**: `Challenge 5 compliance foundation case for post-incident evidence preservation and review.`
4. Open the new case.
5. Add one custodian associated with the incident scenario. Use a pre-seeded test user if one has been provided in the tenant.
6. Add relevant data sources or locations associated with that custodian, such as Exchange mailbox, OneDrive, or SharePoint site content.
7. Create a hold for the same sources so that relevant content is preserved during the investigation.
8. Create a content search or collection within the case.
9. Use a targeted query that fits the scenario, for example:
   - sensitive project name keywords
   - known document names from the seeded data set
   - a recent date range aligned to the exposure event
10. Run the search or collection.
11. Review the estimated results, items, or statistics that are returned.
12. If the interface supports it in your lab tenant, add the collection to a review set or document why the case stopped at search and hold.
13. Capture evidence of the created case, custodian/data sources, hold, and search results.
14. In your notes, explain how this case would support both a compliance review and a security incident investigation.

## Task 6: Review the file plan and Compliance Manager improvement actions

In this task, you will connect your tactical controls to broader compliance operations.

1. In Microsoft Purview, open **Solutions** > **Records management** and then open **File plan**.
2. Review the file plan entries and locate the retention label you created, if it has already propagated.
3. Examine the metadata fields available in the file plan, such as business function, category, citation, or authority fields if present.
4. In your notes, describe how the file plan helps records managers track labels beyond simply publishing them.
5. Next, open **Solutions** > **Compliance Manager**.
6. Review the **Improvement actions** or **Controls** area.
7. Filter or browse for actions related to data protection, records management, audit, or investigation readiness.
8. Open one improvement action and review:
   - The control objective
   - The implementation status
   - What evidence Microsoft manages versus what your organization must implement
9. Mark one action in your notes as a recommended next step for strengthening the organization after the exposure event.
10. Save screenshots or notes that can support your final remediation narrative in Challenge 7.

<validation step="final investigation/remediation deliverables"/>

## Summary

In this challenge, you established the compliance foundation needed to support defensible investigations and long-term governance. You validated audit visibility, created a supervised communications policy, configured retention and records controls, opened an eDiscovery case with preservation and search, and reviewed operational follow-up through the file plan and Compliance Manager. These outcomes prepare the team to move from isolated control changes to a sustained compliance operating model that supports the final incident and remediation narrative.
