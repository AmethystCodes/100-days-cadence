## Day 88/100 Days of Cadence

* Updated Name of Contract -> Changed all transactions/scripts to reflect new name
```cadence
import NonFungibleToken from 0x02
import MetadataViews from 0x03

pub contract Badger: NonFungibleToken {

    pub var totalSupply: UInt64

    pub let BadgerCollectionStoragePath: StoragePath
    pub let BadgerCollectionPublicPath: PublicPath
    pub let BadgerMinter: StoragePath

    // Events
    pub event BadgeMinted(id: UInt64, name: String, daysCompleted: UInt64, description: String)

    pub event ContractInitialized()
    pub event Deposit(id: UInt64, to: Address?)
    pub event Withdraw(id: UInt64, from: Address?)

    // Represents a Badge
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

            emit BadgeMinted(id: self.id, name: self.name, daysCompleted: self.daysCompleted, description: self.description)

            Badger.totalSupply = Badger.totalSupply + 1
        } 
    }

    pub resource Collection: NonFungibleToken.CollectionPublic, NonFungibleToken.Receiver, NonFungibleToken.Provider, MetadataViews.ResolverCollection {
        pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

        pub fun deposit(token: @NonFungibleToken.NFT) {
            let nft <- token as! @Badger.NFT
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
            let badgeNFT = nft as! &Badger.NFT
            return badgeNFT as &AnyResource{MetadataViews.Resolver}
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
        pub fun createBadge(recipient: &{NonFungibleToken.CollectionPublic}, name: String, daysCompleted: UInt64, description: String, thumbnail: String) {
            var badge <- create NFT(id: Badger.totalSupply, name: name, daysCompleted: daysCompleted, description: description, thumbnail: thumbnail)
        
            recipient.deposit(token: <- badge)
        }

        pub fun createMinter(): @Minter {
            return <- create Minter()
        }
    }

    init() {
        self.totalSupply = 0

        self.BadgerCollectionStoragePath = /storage/BadgerCollectionStoragePath
        self.BadgerCollectionPublicPath = /public/BadgerCollectionPublicPath
        self.BadgerMinter = /storage/BadgerMinter

        // Create Collection and Link to Public Capability
        self.account.save(<- create Collection(), to: self.BadgerCollectionStoragePath)
        self.account.link<&Badger.Collection{NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection}>(self.BadgerCollectionPublicPath, target: self.BadgerCollectionStoragePath)  

        // Minter Resource
        self.account.save(<- create Minter(), to: self.BadgerMinter)

        emit ContractInitialized()
    }
}
```
* `getIDs` -> Updated capability to fix error
```cadence
import Badger from 0x01
import NonFungibleToken from 0x02
import MetadataViews from 0x03

pub fun main(address: Address): [UInt64] {

    let badgeCollection = getAccount(address).getCapability(Badger.BadgerCollectionPublicPath)
    .borrow<&Badger.Collection{NonFungibleToken.CollectionPublic}>()
    ?? panic("Could not borrow Collection from the account")

    return badgeCollection.getIDs()

}
```

* Transfer NFT transaction
```cadence
import Badger from 0x01
import NonFungibleToken from 0x02

transaction(recipient: Address, id: UInt64) {

    let Collection: &Badger.Collection
    let RecipientCollection: &Badger.Collection{NonFungibleToken.CollectionPublic}

    prepare(acct: AuthAccount) {
        self.Collection = acct.borrow<&Badger.Collection>(from: Badger.BadgerCollectionStoragePath)
                        ?? panic("Cannot borrow Collection from signer")

        self.RecipientCollection = getAccount(recipient).getCapability(Badger.BadgerCollectionPublicPath)
                        .borrow<&Badger.Collection{NonFungibleToken.CollectionPublic}>()
                        ?? panic("Cannot borrow the recipient's Badger Collection")
    }

    execute {
        self.RecipientCollection.deposit(token: <- self.Collection.withdraw(withdrawID: id))
        log("Badge Transferred")

    }
}

```
