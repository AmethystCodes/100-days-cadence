## Day 56/100 Days of Cadence

### 🛠️ Build on Flow | Learn FCL Series

[Build On Flow | Learn FCL: Resolve .find Identity Name to an Address](https://dev.to/onflow/build-on-flow-learn-fcl-4-how-to-resolve-find-identity-name-to-an-address-2po0)

[Build On Flow | Learn FCL: Get a List of NFTs Living at Known Address](https://dev.to/onflow/build-on-flow-learn-fcl-5-get-a-list-of-nfts-living-at-known-address-23on)

* Resolve [.find](https://github.com/findonflow/find) Identity Name to an Address
```cadence

// Import query & config
import { query, config } from "@onflow/fcl";

const api = "https://rest-mainnet.onflow.org";

config().put("accessNode.api", api);

// Resolve Name -> Address
const resolveName = async (name) => {
  const cadence = `
    import FIND from 0x097bafa4e0b48eef
    
    pub fun main(name: String): Address? {
      return FIND.lookupAddress(name)
    }
  `;
 
 const args = (arg, t) => [arg(name, t.String)];
 
 const address = await query({ cadence, args });
 
 console.log(
 `${name} identity has address %c${address}`,
 "color: #36ad68; font-weight: bold"
 );
};

// Resolve Address -> Identity Alias

const resolveAddress = async (address) => {
  const cadence = `
    import FIND from 0x097bafa4e0b48eef

    pub fun main(address: Address): String? {
      return FIND.reverseLookup(address)
    }
  `;

  const args = (arg, t) => [arg(address, t.Address)];

  const name = await query({ cadence, args });

  console.log(
    `${address} address is aliased to %c${name}`,
    "color: #36ad68; font-weight: bold"
  );
};

(async () => {
  console.clear();
  await resolveName("Insert Name you want to resolve");
    await resolveAddress("Insert Address you want to resolve")
})();

```
* Get a list of NFTs from a known address - Using [Flovatar](https://github.com/crash13override/flovatar)
```cadence

Flovatar contract has a `getFlovatars` method

import { query, config } from "@onflow/fcl";

const api = "https://rest-mainnet.onflow.org";

config().put("accessNode.api", api);

const getFlovatars = async (address) => {
  const cadence = `
    import Flovatar from **0x921ea449dffec68a**
    
    pub fun main(address: Address): [Flovatar.FlovatarData] {
      return Flovatar.getFlovatars(address: address)
    }
  `
  
  const args = (arg, t) => [arg(address, t.Address)];
  
  const flovatars = await query({ cadence, args });
  console.log({ flovatars })
};

// New method using an Avatar struct
const getFlovatarsImproved = async (address) => {
  const cadence = `
    import Flovatar from 0x921ea449dffec68a

    pub struct Avatar {
      pub let id: UInt64
      pub let isCreator: Bool

      init(_ id: UInt64, _ isCreator: Bool) {
        self.id = id
        self.isCreator = isCreator
      }
    }

    pub fun main(address: Address): [Avatar] {
      let flovatars = Flovatar.getFlovatars(address: address)

      let data: [Avatar] = []

      // Loop over Flovatars collected by the contract code
      let isCreator = flovatar.metadata.creatorAddress == address
      let avatar = Avatar(flovatar.id, isCreator)

      // Append new instance of Avator into resulting array

      data.append(avatar)
    }
    return data
}
`
const args = (arg, t) => [arg(address, t.Address)];
  
const flovatars = await query({ cadence, args });
console.log({ flovatars })

(async() => {
  const user = "Insert Address"
  await getFlovatarsImproved(user)
})();

```
