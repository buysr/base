# Buys Landing Page

> [!NOTE]  
> I try to keep this documentation up to date as much as possible. If you find something that is outdated or incorrect, please open an issue or a pull request.

Welcome to the documentation of Buys! I write down:

- Stuff I learn
- Stuff I find interesting
- Stuff I want to remember
- Stuff I want to share
- Stuff I did not find easily on the internet
- More stuff ...

## Quick Reference

- **[Azure Policy evaluationDelay: 87% less 🐢](./docs/evaluationDelay.MD)**  
  Learn how to reduce the default delay before Azure Policy effects (such as `deployIfNotExists`) are triggered. Adjusting the `evaluationDelay` property can help your policies take effect almost immediately after resource provisioning.
- **[Databricks DNS Diaries 📓 Public auth, Private workspace](./docs/hybridDatabricks.MD)**  
  Guidance on setting up Azure Databricks with a hybrid approach: private workspace access via Private Link, while using public endpoints for authentication. This setup can help reduce costs while maintaining security.
- **[Bastion Tunnel 🛣️ Vision: local access to Private Azure Resources](./docs/bastionTunneling.MD)**  
  Ever wondered how to access a Azure Key Vault with a Private Endpoint from your local client web browser using Azure Bastion Tunneling? Press click to find out more!
- **[🔍 Helm's .Files.Glob Limitation: Why Parent Charts Can't Read Subchart Files](./docs/helmFilesGlob.md)**  
  A deep dive into why `.Files.Glob` from a parent chart cannot read configuration files stored in a subchart, and practical solutions to work around this Helm limitation.
