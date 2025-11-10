# Databricks DNS Diaries 📓 Public auth, Private workspace

> [!NOTE]  
> I try to keep this documentation up to date as much as possible. If you find something that is outdated or incorrect, please open an issue or a pull request.

## Short introduction

Azure Databricks supports Private Endpoints. For a fully private setup, you typically deploy two Private Endpoints:

- **`browser_authentication`** (aka **pl-auth**) — used for interactive SSO.
- **`databricks_ui_api`** — used to privately access the workspace UI/API.

## Situation

In a shared Private DNS Zone design you can’t create more than a single **pl-auth** Private Endpoint per **region**. **Why?**

The auth endpoint namespace is regional and reused (for example `westeurope.pl-auth.azuredatabricks.net`). If you deploy multiple workspaces in the same region, they must share the same **pl-auth** Private Endpoint and corresponding DNS records.

Check out the diagrams below for a visual explanation:

- [Single Private DNS Zone](#single-private-dns-zone)
- [Centralized Private DNS Zone](#centralized-private-dns-zone)

### Option 1: Create a dedicated Azure Databricks workspace per region

This is the Microsoft-recommended approach. [See the guidance on Microsoft Learn](https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/private-link-standard?utm_source=chatgpt.com#step-4-create-a-private-endpoint-to-support-sso-for-web-browser-access).

**Pros:**

- Aligns with Microsoft best practice.

**Cons:**

- Additional cost for a dedicated “auth host” workspace in each region.

### Option 2: Hybrid setup (Public Authentication, Private Workspace)

An alternative is a hybrid setup: do **not** create the **pl-auth** Private Endpoint. Authentication flows over the **public** endpoint, while workspace access (UI/API) stays **private** via the `databricks_ui_api` Private Endpoint.

See [How to configure the hybrid setup](#how-to-configure-the-hybrid-setup).

**Pros:**

- Simple
- No extra workspace cost

**Cons:**

- Uses a public endpoint for auth; assess if this fits your risk posture ([see below](#potential-security-risks-explained)).

## Potential security risks explained

With the hybrid setup, the authentication flow traverses the **public Internet**—but over **HTTPS/TLS** end-to-end.

High level:

1. The user is redirected to the regional auth endpoint (`<region>.azuredatabricks.net`).
2. The user authenticates with Microsoft Entra ID.
3. An auth token is issued.
4. The user’s browser (and tools) then talk to the workspace **privately** via `databricks_ui_api` over Private Link.

In practice, traffic to the auth endpoint is served by Microsoft-operated infrastructure and typically rides Microsoft’s global backbone before any late hand-off. Still, decide whether public auth is acceptable for your organization. If you require **zero** public traffic, use Option 1.

## How to configure the hybrid setup

**Requirements:**

- A centralized (or single) Private DNS Zone: `privatelink.azuredatabricks.net`.
- If centralized (hub-and-spoke), link all spoke VNets to this zone.
- **CNAME records** in that Private DNS Zone for each region you deploy, pointing to the **public** regional auth host.

**Records to create in the Private DNS Zone:**

> In Azure, the **record name** is relative to the zone. The table shows both the fully qualified form and the relative name you actually enter.

| Record (FQDN)                                           | Relative name in zone `privatelink.azuredatabricks.net` | Type  | Value (target)                      |
| ------------------------------------------------------- | ------------------------------------------------------- | ----- | ----------------------------------- |
| `westeurope.pl-auth.privatelink.azuredatabricks.net`    | `westeurope.pl-auth`                                    | CNAME | `westeurope.azuredatabricks.net`    |
| `westeurope-c2.pl-auth.privatelink.azuredatabricks.net` | `westeurope-c2.pl-auth`                                 | CNAME | `westeurope-c2.azuredatabricks.net` |

> Only add shard labels that actually exist in your region (e.g., `-c2` may exist; `-c3` often does not in West Europe).

Also ensure the workspace’s **`databricks_ui_api`** Private Endpoint is deployed in the workspace VNet and that its NIC is registered with the same `privatelink.azuredatabricks.net` zone. That gives you `adb-<id>.privatelink.azuredatabricks.net` → **private IP**.

### Diagrams

#### Single Private DNS Zone

![Single Private DNS Zone](../assets/hybrid_setup-for-azure_databricks-pubic_auth-private_workspace-Single%20Private%20DNS%20Zone.drawio.png)

#### Centralized Private DNS Zone

![Centralized Private DNS Zone](../assets/hybrid_setup-for-azure_databricks-pubic_auth-private_workspace-Centralized%20Private%20DNS%20Zone.drawio.png)

## Quick troubleshooting (from a Windows VM)

```cmd
:: Public auth should resolve to a public IP (through your resolver)
nslookup westeurope.pl-auth.azuredatabricks.net

:: The intermediate privatelink label should return your CNAME to the public apex
nslookup -type=CNAME westeurope.pl-auth.privatelink.azuredatabricks.net

:: Compare with Azure DNS directly
nslookup westeurope.pl-auth.azuredatabricks.net 168.63.129.16

:: Workspace UI/API must resolve to a private IP
nslookup adb-<workspace-id>.privatelink.azuredatabricks.net

:: Basic reachability checks
curl -I https://westeurope.pl-auth.azuredatabricks.net/
curl -I --resolve adb-<workspace-id>.privatelink.azuredatabricks.net:443:<PRIVATE_IP> ^
  https://adb-<workspace-id>.privatelink.azuredatabricks.net/
