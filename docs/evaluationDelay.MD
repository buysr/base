# Azure Policy evaluationDelay: 87% less 🐢

Before Azure Policy takes action via a deployIfNotExists effect, it can take some time. By default this is: PT10M (which means a default of 10 minutes)

To accelerate this, you can adjust the **evaluationDelay** property inside the Azure Policy Definition. Checkout this [GitHub Issue](https://github.com/Azure/azure-policy/issues/1050).

## Example scenario

You deploy an Azure KeyVault and you have a Azure Policy in-place to do the following:

- Create a Private Endpoint for the KeyVault
- Create an A-record in the Private DNS Zone for the KeyVault, if it does not exist.

But you experience a delay of 10 minutes before the Private Endpoint is created and the A-record is created in the Private DNS Zone. As explained before this is because of the delay of 10 minutes. To shorten the delay, you can set the **evaluationDelay** to: **AfterProvisioningSuccess**

Have a look at the code below to see how to do this:

```json
{
  "properties": {
    "policyRule": {
      "then": {
        "details": {
          
          "evaluationDelay": "AfterProvisioningSuccess",

          "deployment": {
          }
        }
      }
    }
  }
}
```

Also checkout the [evaluationDelay documentation on Microsoft Learn](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-deploy-if-not-exists#deployifnotexists-properties) for more information about the evaluationDelay property.

## Results

So in this example, the delay is reduced from 10 minutes to near **zero minutes**. This means that the Private Endpoint and A-record are created almost immediately after the KeyVault is created. This is a huge improvement and can save you a lot of time and effort.

## Example Policy Definition

In this file inside this repository you can find an example of a Policy Definition that uses the evaluationDelay property:

- [Azure Policy Definition](../src/policies/evaluationDelay.json)
