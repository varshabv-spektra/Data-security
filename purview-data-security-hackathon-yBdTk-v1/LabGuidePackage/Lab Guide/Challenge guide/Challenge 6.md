# Challenge 06: Data Governance with Microsoft Purview

**Estimated Duration:** 1 hour

---

## Scenario

After addressing immediate exposure risks, the response team now needs stronger governance visibility. In this challenge, you will use Microsoft Purview Data Map and Unified Catalog to organize discovered assets, confirm metadata and sensitive classifications, create a business-aligned collection hierarchy, publish a glossary term, and review governance health — moving the organization from reactive response to governed stewardship.

---

## What You Need to Do

Validate governance readiness and curate a meaningful governance structure around discovered data:

1. Review the governance environment and available solutions
2. Inspect Data Map sources, scans, and discovered assets
3. Create a collection hierarchy aligned to a business domain
4. Assign collection-scoped governance roles
5. Create and publish a governance domain and glossary term
6. Link business context to assets and review governance health

---

## Task 1: Sign In and Review the Governance Environment

**Portal:** [https://purview.microsoft.com](https://purview.microsoft.com)

Sign in using the lab credentials above. After signing in, navigate to **Solutions** and confirm access to:

- **Data Map**
- **Unified Catalog**

> **Important:** This challenge assumes the tenant includes pre-staged governance readiness. If a scan source, governance role, or Unified Catalog feature is missing, document the gap and continue with the available portal experience.

---

## Task 2: Review Data Map Sources, Scans, and Discovered Assets

1. In **Data Map** > **Data sources**, review whether any data sources are registered and available.

2. Navigate to **Solutions** > **Unified Catalog** and review the **Overview** page, noting the available sections:
   - Model your data estate for your business
   - Federate your Data Governance
   - Empower your users to innovate with your data

> **Note:** Data Map is the metadata foundation for governance; Unified Catalog is the searchable experience for discovering and curating scanned assets. You are validating metadata visibility, not accessing underlying business data.

<validation step="DSPM / governance progress"/>

---

## Task 3: Create and Organize a Collection Hierarchy

Navigate to **Data Map** > **Domains** and create the following two-level collection structure.

### Collections to Create

| Collection | Display Name | Collection Admin | Parent |
|---|---|---|---|
| First | `Finance` | OTUWAMOC (Service principal) | Root domain |
| Second | `Finance-Sensitive` | ODL_User | Finance |

After creation, verify in **Domains** that:
- `Finance` is listed under the domain
- `Finance-Sensitive` is listed under `Finance`
- The collection path reads **Finance → Finance-Sensitive**

> **Tip:** Keep the hierarchy small and easy to explain for hackathon timing. You only need enough structure to demonstrate business alignment and scoped stewardship.

---

## Task 4: Assign Collection-Scoped Governance Roles

Open the **Finance-Sensitive** collection and select the **Role assignments** tab.

Review the configured role groups and verify users are assigned to:
- Collection admins
- Data curators
- Data readers
- Data source admins

Click **Edit role assignments** > **Data curators** and verify that **ODL_User** is listed under **Inherited data curators**. Click **OK** to retain the inherited assignment without changes.

Confirm that **ODL_User** appears under all four inherited role categories — no additional assignments should be required.

> **Important:** Use the least-privilege role that still enables the required governance action. Overusing collection administrator permissions weakens the stewardship model.

---

## Task 5: Create and Publish a Glossary Term

### Part A — Create a Governance Domain

Navigate to **Unified Catalog** > **Catalog management** > **Governance domains** > **Create governance domain**.

| Setting | Value |
|---|---|
| Name | `Finance` |
| Description | Governance domain for financial and sensitive business data |
| Type | Functional unit |

After creation, select the **Finance** domain and click **Publish**. Verify the status shows **Published**.

### Part B — Create and Publish a Glossary Term

Navigate to the **Finance** governance domain > **Glossary terms** > **New term**.

| Setting | Value |
|---|---|
| Governance domain | Finance |
| Name | `Regulated Financial Record` |
| Description | Business records containing regulated financial information that must be protected, retained, and governed according to compliance requirements. |
| Owner | ODL_User |

After creation, open the term and click **Publish**. Verify the status changes to **Published**.

> **Note:** Per Microsoft Learn, glossary terms are created in a governance domain and begin as draft terms. Publishing makes the term visible broadly and supports consistent business vocabulary across the catalog.

---

## Task 6: Link Glossary Context to Assets and Review Governance Health

1. On the **Regulated Financial Record** glossary term page, confirm:
   - Governance domain: Finance
   - Status: Published
   - Owner: ODL_User

2. Navigate to **Unified Catalog** > **Health management** > **Controls** and review the dashboard summary (Active, Not healthy, Fair, Healthy, and Expired controls).

3. Navigate to **Health management** > **Data quality** and review quality metrics for the **Finance** governance domain across data products and assets.

4. Navigate to **Health management** > **Actions** and review the action items summary by severity (High, Medium, Low).

5. Navigate to **Health management** > **Reports** and verify the following reports are listed and **Active**:
   - Classic assets, Classic catalog adoption, Classic classifications
   - Classic data stewardship, Classic glossary, Classic sensitivity labels
   - Data governance (preview), DQ health report

> **Tip:** If your environment does not permit editing assets, capture evidence that the asset can still be found in Unified Catalog and note which missing role would be needed to attach the glossary term.

<validation step="DSPM / governance progress"/>

---

## Summary

In this challenge, you used Microsoft Purview governance capabilities to move beyond raw discovery into stewardship. You reviewed Data Map metadata, inspected assets in Unified Catalog, created a collection hierarchy, assigned scoped governance roles, published a governance domain and glossary term, linked business context to discovered data, and identified governance health improvements. These actions help the organization reduce ambiguity, improve discoverability, and create a stronger operating model for governed and trusted data use.
