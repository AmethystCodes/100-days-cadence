## Day 87/100 Days of Cadence

* Updated Contract
```cadence
import NonFungibleToken from 0x02
import MetadataViews from 0x03

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
    pub resource NFT: NonFungibleToken.INFT, MetadataViews.Resolver {
        pub let id: UInt64
        pub let name: String
        pub let daysCompleted: UInt64
        pub let description: String
        pub let thumbnail: String

        pub fun getViews(): [Type] {
            return [
                Type<MetadataViews.Display>()
            ]
        }

        pub fun resolveView(_ view: Type): AnyStruct? {
            switch view {
                case Type<MetadataViews.Display>():
                    return MetadataViews.Display(
                        name: self.name,
                        description: self.description,
                        thumbnail: MetadataViews.HTTPFile(
                            url: self.thumbnail
                        )
                    )
            }

            return nil
        }

        init(id: UInt64, name: String, daysCompleted: UInt64, description: String, thumbnail: String) {
            self.id = id
            self.name = name
            self.daysCompleted = daysCompleted
            self.description = description
            self.thumbnail = thumbnail

            emit StreakMinted(id: self.id, name: self.name, daysCompleted: self.daysCompleted, description: self.description)

            StreakTracker.totalSupply = StreakTracker.totalSupply + 1
        } 
    }

    pub resource Collection: NonFungibleToken.CollectionPublic, NonFungibleToken.Receiver, NonFungibleToken.Provider, MetadataViews.ResolverCollection {
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

        pub fun borrowViewResolver(id: UInt64): &AnyResource{MetadataViews.Resolver} {
            let nft = (&self.ownedNFTs[id] as auth &NonFungibleToken.NFT?)!
            let streakNFT = nft as! &StreakTracker.NFT
            return streakNFT as &AnyResource{MetadataViews.Resolver}
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
        pub fun createStreak(recipient: &{NonFungibleToken.CollectionPublic}, name: String, daysCompleted: UInt64, description: String, thumbnail: String) {
            var streak <- create NFT(id: StreakTracker.totalSupply, name: name, daysCompleted: daysCompleted, description: description, thumbnail: thumbnail)
        
            recipient.deposit(token: <- streak)
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

        // Create Collection and Link to Public Capability
        self.account.save(<- create Collection(), to: self.StreakTrackerCollectionStoragePath)
        self.account.link<&StreakTracker.Collection{NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection}>(self.StreakTrackerCollectionPublicPath, target: self.StreakTrackerCollectionStoragePath)  

        // Minter Resource
        self.account.save(<- create Minter(), to: self.StreakTrackerMinter)

        emit ContractInitialized()
    }
}
```

* Script to read Metadata Display
```cadence
import MetadataViews from 0x03
import StreakTracker from 0x01

pub fun main(address: Address, id: UInt64): AnyStruct {
    let account = getAccount(address)

    let collection = account.getCapability(StreakTracker.StreakTrackerCollectionPublicPath)
    .borrow<&{MetadataViews.ResolverCollection}>()
    ?? panic("Could not borrow reference to the Collection")

    let nft = collection.borrowViewResolver(id: id)

    let display = nft.resolveView(Type<MetadataViews.Display>())

    return display
}
```

* Script to read id field
```cadence
import StreakTracker from 0x01
import NonFungibleToken from 0x02

pub fun main(address: Address): [UInt64] {

    let streakCollection = getAccount(address).getCapability(StreakTracker.StreakTrackerCollectionPublicPath)
    .borrow<&StreakTracker.Collection{NonFungibleToken.CollectionPublic}>()
    ?? panic("Could not borrow Collection from the account")

    return streakCollection.getIDs()

}
```

* Script to read All Metadata Views
```cadence
import MetadataViews from 0x03
import StreakTracker from 0x01

pub fun main(address: Address, id: UInt64): [Type]{
    
    let account = getAccount(address)

    let collection = account
        .getCapability(StreakTracker.StreakTrackerCollectionPublicPath)
        .borrow<&{MetadataViews.ResolverCollection}>()
        ?? panic("Could not borrow a reference to the collection")

    let nft = collection.borrowViewResolver(id: id)

    // Get the basic display information for this NFT


    return nft.getViews()
}
```
