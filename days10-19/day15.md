## Day 15/100 Days of Cadence

* Create testnet accounts
```cadence
flow keys generate --network=testnet
```

* Configuring .json file
```cadence
"accounts": {
  "emulator-account": {
    "address": "f8d6e0586b0a20c7",
    "key": "5112883de06b9576af62b9aafa7ead685fb7fb46c495039b1a83649d61bff97c"
  },
  "testnet-account": {
    "address": "YOUR GENERATED ADDRESS",
    "key": {
      "type": "hex",
      "index": 0,
      "signatureAlgorithm": "ECDSA_P256",
      "hashAlgorithm": "SHA3_256",
      "privateKey": "YOUR PRIVATE KEY"
    }
  }
},
"deployments": {
  "testnet": {
    "testnet-account": [
      "ExampleNFT"
    ]
  }
}
```
* Read total supply script
```cadence
import MyNFTCollection from 0x02
pub fun main(): UInt64 {
  let supply = MyNFTCollection.totalSupply

  return supply
}
```
* Create collection transaction
```cadence
transaction {

  prepare(acct: AuthAccount) {
    // Return if account has a collection
    if acct.borrow<&MyNFTCollection.Collection>(from: MyNFTCollection.CollectionStoragePath) != nil {
      return 
    }

    // Create an empty collection
    let collection <- MyNFTCollection.createEmptyCollection()

    // Save to account
    acct.save(<- collection, to: MyNFTCollection.CollectionStoragePath)

    // Link with public capability
    acct.link<&MyNFTCollection.Collection{NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, MyNFTCollection.CollectionPublic}>(MyNFTCollection.CollectionPublicPath, target: MyNFTCollection.CollectionStoragePath) 
  }

  execute {
    log("Collection Created")
  }
}


```
