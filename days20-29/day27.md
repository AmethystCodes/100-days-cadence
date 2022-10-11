## Day 27/100 Days of Cadence

### [CryptoDappy - Mission 3](https://www.cryptodappy.com/missions/mission-3)

* Check Collection
```javascript
export const CHECK_COLLECTION = `
  import DappyContract from 0xDappy
  pub fun main(addr: Address): Bool {
    let ref = getAccount(addr).getCapability<&{DappyContract.CollectionPublic}>(DappyContract.CollectionPublicPath).check()
    return ref
  }
`;
```
* Create Collection Transaction
```javascript
export const CREATE_COLLECTION = `
  import DappyContract from 0xDappy
  transaction {
    prepare(acct: AuthAccount) {
      let collection <- DappyContract.createEmptyCollection()
      acct.save<@DappyContract.Collection>(<-collection, to: DappyContract.CollectionStoragePath)
      acct.link<&{DappyContract.CollectionPublic}>(DappyContract.CollectionPublicPath, target: DappyContract.CollectionStoragePath)
    }
  }
`;
```
* Delete Collection Transaction
```javascript
export const DELETE_COLLECTION = `
  import DappyContract from 0xDappy
  transaction {
    prepare(acct: AuthAccount) {
      let collection <- acct.load<@DappyContract.Collection>(from: DappyContract.CollectionStoragePath)
              ?? panic("Could not load resource") 
      destroy collection
      acct.unlink(DappyContract.CollectionPublicPath)
    }
  }
`;
```
