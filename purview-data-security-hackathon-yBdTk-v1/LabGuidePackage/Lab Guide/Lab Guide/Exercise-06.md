# Challenge 6: Data Governance with Microsoft Purview

### Estimated Duration: 1 Hour

## Scenario

After addressing immediate exposure risks, the response team now needs stronger governance visibility. In this challenge, you will use Microsoft Purview Data Map and Unified Catalog to organize discovered assets, confirm metadata and sensitive classifications, create a business-aligned collection hierarchy, publish a glossary term, and review governance health so the organization can move from reactive response to governed stewardship.

## Overview

In this challenge, you will work in Microsoft Purview to validate governance readiness and curate a small but meaningful governance structure around discovered data. You will register and review a scanned data source, inspect assets in Unified Catalog, scope governance access through collections, define a business-aligned collection model, publish a glossary term, connect that term to discovered assets, and review governance health signals for next-step remediation.

## Objectives

- Task 1: Sign in and review the governance environment
- Task 2: Review Data Map sources, scans, and discovered assets
- Task 3: Create and organize a collection hierarchy
- Task 4: Assign collection-scoped governance roles
- Task 5: Create and publish a glossary term
- Task 6: Link glossary context to assets and review governance health

## Task 1: Sign in and review the governance environment

In this task, you will sign in to the lab environment and confirm that Microsoft Purview governance components needed for the challenge are available.

1. Sign in to the lab VM or browser session using the lab-provided credentials if prompted.
2. Open the Microsoft Purview portal at <https://purview.microsoft.com>.
3. Sign in with the following account:
   - Username: `<inject key="AzureAdUserEmail"></inject>`
   - Password: `<inject key="AzureAdUserPassword"></inject>`
4. Record your deployment reference for screenshots and evidence collection: **Deployment ID: `<inject key="DeploymentID" enableCopy="false"/>`**.
5. In the left navigation, verify that you can access **Data Map** and **Unified Catalog**.
6. Confirm that the tenant already contains the pre-staged governance prerequisites needed for the challenge, including at least one registered source or previously scanned source.
7. Create a notes file on the lab VM desktop named `Challenge6-governance-notes.txt` and record any sources, collections, glossary terms, or health observations that you will reference later.

> [!Important]
> This challenge assumes the tenant includes pre-staged governance readiness. If a live scan source, governance role, or Unified Catalog feature is missing, document the gap in your notes and continue with the available portal experience.

## Task 2: Review Data Map sources, scans, and discovered assets

In this task, you will inspect the Microsoft Purview Data Map and confirm that data source metadata is available for governance work.

1. In Microsoft Purview, open **Data Map**.
2. Select **Sources** and review the available registered data sources.
3. Open a source that appears to be aligned to the hackathon scenario, such as a storage, SQL, or other business-data source prepared for governance discovery.
4. Review the source details and look for evidence that a scan has completed successfully, such as discovered assets, scan history, or classification-related metadata.
5. If the source is already scanned, note the source name and asset count in your notes file.
6. If a new scan can be run in your environment without waiting too long, start the scan only if your facilitator instructs you to do so; otherwise, continue with pre-discovered assets.
7. Switch to **Unified Catalog** and search for assets from the selected source.
8. Open one or more discovered assets and review:
   - Asset name and source
   - Collection path
   - Any visible classifications
   - Schema or column details, where available
9. Capture evidence that sensitive or governance-relevant metadata exists on at least one discovered asset.
10. Add your findings to the notes file.

> [!Note]
> Microsoft Learn describes Data Map as the metadata foundation for governance and Unified Catalog as the searchable experience used to discover and curate scanned assets. You are validating metadata visibility rather than accessing the underlying business data itself.

<validation step="DSPM / governance progress"/>

## Task 3: Create and organize a collection hierarchy

In this task, you will build a collection hierarchy that aligns to a business domain so governance responsibilities can be scoped more clearly.

1. Return to **Data Map**.
2. Open **Collections** or the domains and collections management area available in your tenant experience.
3. Review the existing root collection and any pre-created subcollections.
4. Create a new child collection aligned to a business function relevant to the incident, such as **Finance**, **Legal**, **HR**, or **IncidentResponse**.
5. Under that new collection, create an additional subcollection that further scopes governance responsibility, such as **Finance-Sensitive**, **Claims-Records**, or **SharedInvestigations**.
6. Ensure the names you choose are consistent and business meaningful.
7. Verify that the new hierarchy appears under the parent collection.
8. Record the hierarchy you created in your notes file.

> [!Tip]
> Collections control organization and delegated access in Data Map. Keep the hierarchy small and easy to explain for hackathon timing; you only need enough structure to show business alignment and scoped stewardship.

## Task 4: Assign collection-scoped governance roles

In this task, you will review and assign governance roles at the collection level so stewardship can be delegated appropriately.

1. Open the collection you created in the previous task.
2. Go to the **Role assignments**, **Access control**, or equivalent permissions page for that collection.
3. Review the available built-in roles, such as:
   - **Collection administrator**
   - **Data curator**
   - **Data reader**
   - **Data source administrator**
4. Assign an appropriate role to a user or group available in the tenant. If your environment includes a seeded governance group or user persona, use that identity.
5. Prefer one of these patterns:
   - Assign **Data curator** to a stewardship identity that needs to manage asset metadata.
   - Assign **Data reader** to an analyst or reviewer identity.
   - Assign **Collection administrator** only when the scenario requires delegated collection management.
6. Save the role assignment.
7. Verify whether the role inherits to subcollections and note that behavior.
8. Record the role, assignee, and collection scope in your notes file.

> [!Important]
> Use the least-privilege role that still enables the required governance action. Overusing collection administrator permissions weakens the stewardship model you are trying to demonstrate.

## Task 5: Create and publish a glossary term

In this task, you will create a governance glossary term that gives business meaning to discovered data.

1. Open **Unified Catalog**.
2. Under **Catalog management**, open **Governance domains**.
3. Select the governance domain where you will maintain business terminology for this challenge.
4. Open the **Glossary terms** area for that domain.
5. Select **New term**.
6. Create a term related to the scenario, for example:
   - **Regulated Financial Record**
   - **Incident Evidence Package**
   - **Customer Sensitive Data**
7. Provide a clear business definition that explains why the term matters in this regulated environment.
8. Assign an owner if your tenant has an appropriate user available.
9. Optionally define a parent term if you want to create a simple hierarchy.
10. Complete the wizard and create the term.
11. Open the newly created term and publish it so it becomes visible for broader catalog use.
12. Record the final term name and definition in your notes file.

> [!Note]
> In Microsoft Learn, glossary terms are created in a governance domain and begin as draft terms. Publishing makes the term visible more broadly and supports consistent business vocabulary across the catalog.

## Task 6: Link glossary context to assets and review governance health

In this task, you will connect business context to scanned assets and review governance health signals for remediation planning.

1. In **Unified Catalog**, search for a discovered asset that is relevant to your selected source.
2. Open the asset details page.
3. If your assigned permissions allow it, edit the asset and attach the glossary term you created.
4. Save the asset changes.
5. Verify that the glossary term now appears on the asset details page.
6. Review the asset for visible classifications, descriptions, ownership fields, or other governance metadata.
7. Open the governance health, health controls, health actions, data estate health, or governance report experience available in your tenant.
8. Identify at least one governance gap or improvement opportunity, such as missing glossary coverage, incomplete ownership, low metadata completeness, or poor classification coverage.
9. Record one remediation action you would recommend to improve the health posture.
10. Save screenshots or notes that show:
    - The linked glossary term
    - The asset location or collection path
    - One health observation or improvement action

> [!Tip]
> If your environment does not permit editing the asset, capture evidence that the asset can still be found in Unified Catalog and explain which missing role would be needed to attach the glossary term.

<validation step="DSPM / governance progress"/>

## Summary

In this challenge, you used Microsoft Purview governance capabilities to move beyond raw discovery into stewardship. You reviewed Data Map metadata, inspected assets in Unified Catalog, created a collection hierarchy, assigned scoped governance roles, published a glossary term, linked business context to discovered data, and identified governance health improvements. These actions help the organization reduce ambiguity, improve discoverability, and create a stronger operating model for governed and trusted data use.
