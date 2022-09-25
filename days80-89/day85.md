## Day 85/100 Days of Cadence

* Transaction to setup a collection
```cadence
import StreakTracker from 0x01
import NonFungibleToken from 0x02
import MetadataViews from 0x03

transaction {

  prepare(acct: AuthAccount) {
    // Return if account has a collection
    if acct.borrow<&StreakTracker.Collection>(from: StreakTracker.StreakTrackerCollectionStoragePath) != nil {
      return 
    }

    // Create an empty collection
    let collection <- StreakTracker.createEmptyCollection()

    // Save to account
    acct.save(<- collection, to: StreakTracker.StreakTrackerCollectionStoragePath)

    // Link with public capability
    acct.link<&{NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection}>(StreakTracker.StreakTrackerCollectionPublicPath, target: StreakTracker.StreakTrackerCollectionStoragePath) 
  }

  execute {
    log("Setup Account")
  }
}

```
* Transaction to mint NFT using the Minter resource
```cadence
import StreakTracker from 0x01
import NonFungibleToken from 0x02

transaction(address: Address, name: String, daysCompleted: UInt64, description: String, thumbnail: String) {

    // Variable for storing the minter reference
    let minter: &StreakTracker.Minter

    prepare(acct: AuthAccount) {
        // Borrow reference to NFT Minter
        self.minter = acct.borrow<&StreakTracker.Minter>(from: StreakTracker.StreakTrackerMinter)
            ?? panic("Could not borrow reference to NFT Minter")
    }

    execute {
        // Borrow recipient's reference to public NFT Collection
        let receiver = getAccount(address).getCapability(StreakTracker.StreakTrackerCollectionPublicPath)
        .borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not get receiver reference to the NFT Collection")

        // Mint and deposit NFT to receiver's account
        self.minter.createStreak(recipient: receiver, name: name, daysCompleted: daysCompleted, description: description, thumbnail: thumbnail)
        
        log("Minted NFT")
    }
}
```
