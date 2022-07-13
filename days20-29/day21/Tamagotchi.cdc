// Adapted from: https://nftschool.dev/tutorial/flow-nft-marketplace/#building-pet-store
// #100DaysOfCadence

pub contract Tamagotchi {

    pub var owners: {UInt64: Address}

    pub let CollectionStoragePath: StoragePath
    pub let CollectionPublicPath: PublicPath

    pub resource interface INFT {

        pub fun withdraw(id: UInt64): @NFT

        pub fun deposit(token: @NFT)

        pub fun getTokenIDs(): [UInt64]

        pub fun getTokenMetadata(id: UInt64) : {String: String}
    }

    pub resource NFT {
        
        // Unique ID for each NFT
        pub let id: UInt64

        // String mapping for metadata 
        pub var metadata: {String: String}

        // Initailize 
        init(id: UInt64, metadata: {String: String}) {
            self.id = id
            self.metadata = metadata
        }
    }

    pub resource Collection: INFT {

        // access(account) means the declaration
        // is only available in the 
        pub var ownedNFTs: @{UInt64: NFT}

        init() {
            self.ownedNFTs <- {}
        }
        
        pub fun withdraw(id: UInt64): @NFT {
            let token <- self.ownedNFTs.remove(key: id)
            return <- token!
        }

        pub fun deposit(token: @NFT) {
            self.ownedNFTs[token.id] <-! token
        }

        pub fun getTokenIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        pub fun getTokenMetadata(id: UInt64) : {String: String} {
            let metadata = self.ownedNFTs[id]?.metadata
            return metadata!
        }

        destroy() {
            destroy self.ownedNFTs
        }
    }

    pub fun createNFTCollection(): @Collection {
        return <- create Collection()
    }

    pub resource Minter {
        pub var idCounter: UInt64

        init() {
            self.idCounter = 1
        }

        pub fun mint(_ metadata: {String: String}): @NFT {
            
            // Creates new resource with the current ID
            let token <- create NFT(id: self.idCounter, metadata: metadata)
            
            // Saves the current owners address to the dictionary
            Tamagotchi.owners[self.idCounter] = Tamagotchi.account.address
            
            // Increment the ID
            self.idCounter = self.idCounter + 1 as UInt64

            return <- token
        }
    }

    init() {
        
        // Sets `owners` to an empty dictionary
        self.owners = {}

        // Set Named Paths
        self.CollectionStoragePath = /storage/TamagotchiCollection
        self.CollectionPublicPath = /public/TamagotchiCollection

        // Create new Collection and saves to `/storage/` domain
        self.account.save(<- create Collection(), to: self.CollectionStoragePath)

        // Links the `INFT` interface to the `/public/` domain
        self.account.link<&{INFT}>(self.CollectionPublicPath, target: self.CollectionStoragePath)

        // Creates a new Minter and saves it to `/storage/` domain
        self.account.save(<- create Minter(), to: /storage/Minter)
    }

}
