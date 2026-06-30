# Challenge 05: Compliance Foundations

**Estimated Duration:** 1 hour

---

## Scenario

After implementing labels, DLP controls, and initial investigative workflows, the response team now needs to establish durable compliance foundations for the tenant. In this challenge, you validate audit readiness, configure supervision controls for risky communications, apply retention and records controls for critical business data, and create an eDiscovery workspace that preserves evidence for follow-up investigation.

---

## What You Need to Do

Use Microsoft Purview to create a defensible compliance baseline supporting both day-to-day governance and post-incident response:

1. Validate audit readiness and confirm compliance surfaces are available
2. Run an audit log search for recent compliance activity
3. Create a Communication Compliance policy for risky communications
4. Configure retention policies and a records retention label
5. Create an eDiscovery case with a content hold and search
6. Review the file plan and Compliance Manager improvement actions

---

## Task 1: Sign In and Validate Audit Readiness

**Portal:** [https://purview.microsoft.com](https://purview.microsoft.com)

Sign in using the lab credentials above. After signing in:

Navigate to **Solutions** and confirm the following areas are accessible:

- Audit
- Communication Compliance
- Data Lifecycle Management
- Records Management
- eDiscovery
- Compliance Manager

Create a brief evidence note listing which solutions are visible and which appear pre-staged by the tenant team.

> **Important:** Some Purview experiences depend on licensing, role groups, and pre-enabled prerequisites. If a feature is visible but opens in read-only mode, continue with observation and evidence capture rather than blocking your progress.

---

## Task 2: Run an Audit Search for Recent Compliance Activity

Navigate to **Solutions** > **Audit** > **Search** and configure a search with the following settings:

| Setting | Value |
|---|---|
| Date range | Last 7 days |
| Activities | Accessed file, Modified file, DLP-related activities |
| Search name | `Audit Search` |

Run the search and verify the job completes with a **Completed** status and returns audit records.

> **Tip:** Audit results can take time to appear. If the tenant has pre-seeded evidence, prioritize reviewing existing entries rather than waiting for new activity to ingest.

---

## Task 3: Create a Communication Compliance Policy

Navigate to **Solutions** > **Communication Compliance** > **Policies** > **Create policy**.

Use the **Detect inappropriate content** template and configure:

| Setting | Value |
|---|---|
| Policy name | Hackathon-CommPolicy-<inject key="DeploymentID"></inject> |
| Reviewer | ODL_User |
| Preserve policy matches | Global Setting |
| Monitored locations | Teams and Viva Engage (default from template) |

After creation, verify the policy appears in the **Policies** list with a **Healthy** policy health status.

> **Note:** Communication Compliance templates and wizard pages can vary by tenant features and licensing. The key outcome is a supervised communications policy that monitors regulated or risky content.

---

## Task 4: Create Retention and Records Coverage

### Part A — Retention Policy

Navigate to **Solutions** > **Data Lifecycle Management** > **Policies** > **Retention policies** > **+ New retention policy**.

| Setting | Value |
|---|---|
| Policy name | Hackathon-BaselineRetention-<inject key="DeploymentID"></inject> |
| Policy type | Static |
| Locations | Exchange mailboxes, SharePoint classic and communication sites, OneDrive accounts |
| Retention period | 7 years |

### Part B — Records Retention Label

Navigate to **Solutions** > **Records Management** > **File plan** > **Create a label**.

| Setting | Value |
|---|---|
| Label name | Investigation Record - 7 Years - <inject key="DeploymentID"></inject> |
| Retention period | 7 years |
| After retention period | Start a disposition review |
| Disposition review stage name | `Disposition Review Stage` |
| Reviewer | ODL_User |

After creation, verify the label appears in the **File plan** list with a 7-year retention duration and **Review required** action.

> **Important:** Retention policies provide broad lifecycle coverage, while retention labels provide item-level control and support records declaration and disposition review. Use both concepts intentionally in your narrative.

---

## Task 5: Create an eDiscovery Case with Custodian, Hold, and Content Search

Navigate to **Solutions** > **eDiscovery** > **Cases** > **Create case**.

### Case Details

| Setting | Value |
|---|---|
| Case name | Hackathon-Exposure-Investigation-<inject key="DeploymentID"></inject> |
| Description | Challenge 5 compliance foundation case for post-incident evidence preservation and review |

### Content Search

Within the case, create a content search:

| Setting | Value |
|---|---|
| Search name | `Incident Content Search` |
| Keywords | confidential, finance, project |
| Data sources | All people and groups + All public folders (tenant-wide) |

Run the query and generate search statistics.

### Hold Policy

Within the case, create a hold policy:

| Setting | Value |
|---|---|
| Policy name | `Incident Evidence Hold` |
| Source | ODL_User (search for "odl") |

Apply the hold and verify the **ODL_User** mailbox shows **Hold status: On hold**.

---

## Task 6: Review the File Plan and Compliance Manager Improvement Actions

1. In **Records Management** > **File plan**, confirm `Investigation Record - 7 Years` is listed with:
   - Retention duration: 7 years
   - Action: Review required

2. Navigate to **Solutions** > **Compliance Manager** > **Improvement actions**.

3. Locate and open **Perform real-time threat detection** and review:
   - Service: Microsoft 365
   - Testing type: Manual
   - Testing source: User verified

<validation step="final investigation/remediation deliverables"/>

---

## Summary

In this challenge, you established the compliance foundation needed to support defensible investigations and long-term governance. You validated audit visibility, created a supervised communications policy, configured retention and records controls, opened an eDiscovery case with preservation and search, and reviewed operational follow-up through the file plan and Compliance Manager. These outcomes prepare the team to move from isolated control changes to a sustained compliance operating model.