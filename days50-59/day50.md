## Day 50/100 Days of Cadence

Worked through the NFTSchool Flow Marketplace tutorial. Added transactions and scripts but spent time debugging the smart contract and transactions. 

* Transactions

```cadence

// Initailizing a collection

import Tamagotchi from 0x01

transaction() {
  prepare(account: AuthAccount) {
    let collection <- create Tamagotchi.Collection()

    account.save<@Tamagotchi.Collection>(<-collection, to: Tamagotchi.CollectionStoragePath)

    account.link<&{Tamagotchi.NFTReceiver}>(Tamagotchi.CollectionPublicPath, target: Tamagotchi.CollectionStoragePath)
  }
}
```
```cadence

// Minting Tokens

import Tamagotchi from 0x01

transaction(metadata: {String: String}) {

  // Unauthorized reference to `NFT Receiver` interface
  let receiverRef: &{Tamagotchi.NFTReceiver}

  // Authorized reference to the `NFT Minter` interface
  let minterRef: &Tamagotchi.NFTMinter

  prepare(account: AuthAccount) {
    self.receiverRef = account.getCapability<&{Tamagotchi.NFTReceiver}>(/public/NFTReceiver)
      .borrow() ?? panic("Could not borrow receiver reference")
  }

  execute {
    let newToken <- self.minterRef.mint(metadata)

    self.receiverRef.deposit(token: <-newToken)
  }
}
```

```cadence 

// Transfer Tokens

import Tamagotchi from 0x01

transaction(tokenId: UInt64, recipientAddr: Address) {
  let token: @Tamagotchi.NFT

  prepare(account: AuthAccount) {
    let collectionRef = account.borrow<&Tamagotchi.Collection>(from: Tamagotchi.CollectionStoragePath) ?? panic("Could not borrow a reference to the owner's collection")

    self.token <- collectionRef.withdraw(id: tokenId)
  }

  execute {
    let recipient = getAccount(recipientAddr)

    let receiverRef = recipient.getCapability<&{Tamagotchi.NFTReceiver}>(Tamagotchi.CollectionPublicPath)
  }
}

```
