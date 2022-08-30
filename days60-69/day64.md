## Day 64/100 Days of Cadence

### 🔗[CryptoDappy](https://github.com/bebner/crypto-dappy)

* Collection Deletion
```cadence
import DappyContract from 0xDappy

transaction() {
  prepare(signer: AuthAccount) {
    let collectionRef <- acct.load<@DappyContract.Collection>(from: DappyContract.Collection)
      ?? panic("Could not borrow collection reference")
    
    // Destorys the collection
    destroy collectionRef
    
    // Unlinks the Public Path
    acct.unlink(DappyContract.CollectionPublicPath)
  }
}
```

* Creating a collection
```cadence
import DappyContract from 0xDappy

transaction() {
  prepare(signer: AuthAccount) {
    // Creates an empty collection
    let collection <- DappyContract.createEmptyCollection()
    // Saves a collection to the Account's Storage Path
    acct.save<@DappyContract.Collection>(<- collection, to: DappyContract.CollectionStoragePath)
    // Links the Account's storage path to the Public path
    acct.link<&{DappyContract.CollectionPublic}>(DappyContract.CollectionPublicPath, target: DappyContract.CollectionStoragePath)
  }
}

```
