## Day 79/100 Days of Cadence

* Updated Contract with Minter Resource and Events
```cadence
pub contract StreakTracker {

    pub var totalSupply: UInt64

    pub let StreakTrackerCollectionStoragePath: StoragePath
    pub let StreakTrackerCollectionPublicPath: PublicPath

    pub event StreakMinted(id: UInt64, name: String, daysCompleted: UInt64, description: String)

    pub event Deposit(id: UInt64, to: Address?)
    pub event Withdraw(id: UInt64, from: Address?)

    pub resource Streak {
        pub let id: UInt64
        pub let name: String
        pub let daysCompleted: UInt64
        pub var description: String

        pub fun changeDescription(newDescription: String) {
            self.description = newDescription
        }

        init(name: String, daysCompleted: UInt64, description: String) {
            self.id = self.uuid
            self.name = name
            self.daysCompleted = daysCompleted
            self.description = description

            emit StreakMinted(id: self.id, name: self.name, daysCompleted: self.daysCompleted, description: self.description)

            StreakTracker.totalSupply = StreakTracker.totalSupply + 1
        } 
    }

    pub resource interface CollectionPublic {
        pub fun deposit(token: @Streak)
        pub fun getIDs(): [UInt64]
        pub fun borrowNFT(id: UInt64): &Streak
    }

    pub resource Collection {
        pub var ownedNFTs: @{UInt64: Streak}

        pub fun deposit(token: @Streak) {
            let nft <- token as! @Streak
            let id = nft.id
            
            emit Deposit(id: id, to: self.owner!.address)
            self.ownedNFTs[id] <-! nft
        }

        pub fun withdraw(withdrawID: UInt64): @Streak {
            let nft <- self.ownedNFTs.remove(key: withdrawID)
                ?? panic("This NFT does not exist in the Collection")

            emit Withdraw(id: withdrawID, from: self.owner!.address)

            return <- nft
        }

        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        pub fun borrowNFT(id: UInt64): &Streak {
            return (&self.ownedNFTs[id]as &Streak?)!
        }

        init() {
            self.ownedNFTs <- {}
        }

        destroy() {
            destroy self.ownedNFTs
        }
    }

    pub fun createEmptyCollection(): @Collection {
        return <- create Collection()
    }

    pub resource Minter {
        pub fun createStreak(name: String, daysCompleted: UInt64, description: String): @Streak {
            return <- create Streak(name: name, daysCompleted: daysCompleted, description: description)
        }

        pub fun createMinter(): @Minter {
            return <- create Minter()
        }
    }

    init() {
        self.totalSupply = 0

        self.StreakTrackerCollectionStoragePath = /storage/StreakTrackerCollectionStoragePath
        self.StreakTrackerCollectionPublicPath = /public/StreakTrackerCollectionPublicPath

        // Minter Resource
        self.account.save(<- create Minter(), to: /storage/StreakTrackerCollectionStoragePath)
    }
}

```
* Transaction for transferring
```cadence
import StreakTracker from 0x01

transaction(id: UInt64, recipient: Address) {

  prepare(acct: AuthAccount) {
    let signersCollection = acct.borrow<&StreakTracker.Collection>(from: StreakTracker.StreakTrackerCollectionStoragePath)
                            ?? panic("Signer does not have a Streak Tracker Collection")
    
    let recipientCollection = getAccount(recipient).getCapability(StreakTracker.StreakTrackerCollectionPublicPath)
                                .borrow<&StreakTracker.Collection{StreakTracker.CollectionPublic}>()

    let nft <- signersCollection.withdraw(withdrawID: id)

    recipientCollection.deposit(token: <- nft)
  }
}
```
