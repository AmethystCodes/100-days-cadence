## Day 57/100 Days of Cadence

### 🛠️ Build On Flow | Learn FCL Series

[How to Query Latest Block in the Chain](https://dev.to/onflow/build-on-flow-learn-fcl-6-how-to-query-latest-block-in-the-chain-8gh)

[How to Query a Flow Account by Address](https://dev.to/onflow/build-on-flow-learn-fcl-7-how-to-query-flow-account-by-address-439d)

* Query Latest Block in the Chain

```javascript
import { block, config } from "@onflow/fcl";

const api = "https://rest-mainnet.onflow.org";

config().put("accessNode.api", api);

(async () => {
  console.clear();

  const latestBlock = await block({ sealed: true });
  console.log("latestBlock", latestBlock);

  const previousBlock = await block({ height: latestBlock.height - 1 });
  console.log("previousBlock", previousBlock);

  const blockById = await block({ id: previousBlock.parentId });
  console.log("blockById", blockById);
})();
```

* Query a Flow Account by Address
```javascript
import { account, query, config } from "@onflow/fcl";

const api = "https://rest-mainnet.onflow.org";

config().put("accessNode.api", api);

const resolveName = async (name) => {
  const cadence = `
    import FIND from 0x097bafa4e0b48eef

    pub fun main(name: String): Address? {
      return FIND.lookupAddress(name)
    }
  `;

  const args = (arg, t) => [arg(name, t.String)];
  return await query({ cadence, args });
};

(async () => {
  console.clear();

  const address = await resolveName("Insert name")

  if (address) {
  const accountInfo = await account(address);
  console.log({ accountInfo });
  }
})();

```
