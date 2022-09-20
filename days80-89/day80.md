## Day 80/100 Days of Cadence

* Update contract to implement the [Flow NFT Standard](https://github.com/onflow/flow-nft/blob/master/contracts/NonFungibleToken.cdc)

```cadence
import NonFungibleToken from 0x02

pub contract StreakTracker: NonFungibleToken {

    pub var totalSupply: UInt64

    pub let StreakTrackerCollectionStoragePath: StoragePath
    pub let StreakTrackerCollectionPublicPath: PublicPath
    pub let StreakTrackerMinter: StoragePath

    // Events
    pub event StreakMinted(id: UInt64, name: String, daysCompleted: UInt64, description: String)

    pub event ContractInitialized()
    pub event Deposit(id: UInt64, to: Address?)
    pub event Withdraw(id: UInt64, from: Address?)

    // Represents a Streak
    pub resource NFT: NonFungibleToken.INFT {
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

    pub resource Collection: NonFungibleToken.CollectionPublic, NonFungibleToken.Receiver, NonFungibleToken.Provider {
        pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

        pub fun deposit(token: @NonFungibleToken.NFT) {
            let nft <- token as! @StreakTracker.NFT
            let id = nft.id
            
            emit Deposit(id: id, to: self.owner!.address)
            self.ownedNFTs[id] <-! nft
        }

        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
            let nft <- self.ownedNFTs.remove(key: withdrawID)
                ?? panic("This NFT does not exist in the Collection")

            emit Withdraw(id: withdrawID, from: self.owner!.address)

            return <- nft
        }

        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            return (&self.ownedNFTs[id]as &NonFungibleToken.NFT?)!
        }

        init() {
            self.ownedNFTs <- {}
        }

        destroy() {
            destroy self.ownedNFTs
        }
    }

    pub fun createEmptyCollection(): @NonFungibleToken.Collection {
        return <- create Collection()
    }

    pub resource Minter {
        pub fun createStreak(name: String, daysCompleted: UInt64, description: String): @NFT {
            return <- create NFT(name: name, daysCompleted: daysCompleted, description: description)
        }

        pub fun createMinter(): @Minter {
            return <- create Minter()
        }
    }

    init() {
        self.totalSupply = 0

        self.StreakTrackerCollectionStoragePath = /storage/StreakTrackerCollectionStoragePath
        self.StreakTrackerCollectionPublicPath = /public/StreakTrackerCollectionPublicPath
        self.StreakTrackerMinter = /storage/StreakTrackerMinter

        // Minter Resource
        self.account.save(<- create Minter(), to: self.StreakTrackerMinter)

        emit ContractInitialized()
    }
}
```
