## Day 66/100 Days of Cadence

[Send FLOW Tokens to Another Account](https://dev.to/onflow/build-on-flow-learn-fcl-16-how-to-send-flow-tokens-to-another-account-3lph)

### References
* [Get Balance Cadence Script](https://github.com/onflow/flow-ft/blob/master/transactions/scripts/get_balance.cdc)
* [Transfer Tokens Cadence Transaction](https://github.com/onflow/flow-ft/blob/master/transactions/transfer_tokens.cdc)

`testnet-config.js`
```javascript
// Import and config FCL
import { config } from "@onflow/fcl";

config({
  "accessNode.api": "https://rest-testnet.onflow.org",
  "flow.network": "testnet",
  "app.detail.title": "Meow DApp",
  "app.detail.icon": "https://placekitten.com/g/200/200",
  // Wallet Discovery
  "discovery.wallet": "https://fcl-discovery.onflow.org/testnet/authn",
  "discovery.authn.endpoint":
    "https://fcl-discovery.onflow.org/api/testnet/authn",

  // Aliases for the contracts we will use in this example
  "0xFLOW": "0x7e60df042a9c0868",
  "0xFT": "0x9a0766d93b6608b7"
});
```
`index.js`
```javascript

import { query, mutate, tx, reauthenticate } from "@onflow/fcl";
import "./testnet-config";

// Implement `getFlowBalance` function
const getFlowBalance = async (address) => {
  const cadence = `
    import FlowToken from 0xFLOW
    import FungibleToken from 0xFT
    
    pub fun main(address: Address): UFix64 {
      let account = getAccount(address)
      
      let vaultRef = account.getCapability(/public/flowTokenBalance)
        .borrow<&FlowToken.Vault{FungibleToken.Balance}>()
        ?? panic("Could not borrow Balance reference to the Vault")
        
      return vaultRef.balance
    }
  `;
  const args = (arg, t) => [arg(address, t.Address)];
  const balance = await query({ cadence, args });
  console.log({ balance });
  
// Implement `sendFlow` function
const sendFlow = async (recepient, amount) => {
  const cadence = `
    import FungibleToken from 0xFT
    import FlowToken from 0xFLOW

    transaction(recepient: Address, amount: UFix64){
      prepare(signer: AuthAccount){
        let sender = signer.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
          ?? panic("Could not borrow Provider reference to the Vault")

        let receiverAccount = getAccount(recepient)

        let receiver = receiverAccount.getCapability(/public/flowTokenReceiver)
          .borrow<&FlowToken.Vault{FungibleToken.Receiver}>()
          ?? panic("Could not borrow Receiver reference to the Vault")

        let tempVault <- sender.withdraw(amount: amount)
        receiver.deposit(from: <- tempVault)
      }
    }
  `;
    const args = (arg, t) => [arg(recepient, t.Address), arg(amount, t.UFix64)];
    const limit = 500;

    const txId = await mutate({ cadence, args, limit });

    console.log("Waiting for transaction to be sealed...");

    const txDetails = await tx(txId).onceSealed();
    console.log({ txDetails });
  };
};

(async () => {
  console.clear();
  await reauthenticate();
  const recepient = "Enter address here";
  await getFlowBalance(recepient);
  await sendFlow(recepient, "1.337");
  await getFlowBalance(recepient);
})();
```
