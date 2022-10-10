## Day 5/100 Days of Cadence

### Chapter 4.0 Day 4 Quests - Cadence Bootcamp

**Take our NFT contract so far and add comments to every single resource or function explaining what it's doing in your own words.**
```cadence
pub contract CryptoPoops {
  pub var totalSupply: UInt64

  // This is an NFT resource that contains a name,
  // favouriteFood, and luckyNumber
  pub resource NFT {
    pub let id: UInt64

    pub let name: String
    pub let favouriteFood: String
    pub let luckyNumber: Int
    
    // Initalizing id, name, favouriteFood, and luckyNumber
    init(_name: String, _favouriteFood: String, _luckyNumber: Int) {
      self.id = self.uuid

      self.name = _name
      self.favouriteFood = _favouriteFood
      self.luckyNumber = _luckyNumber
    }
  }

  // This is a resource interface that allows us to expose 3 functions:
  // deposit(), getIDs, borrowNFT()
  pub resource interface CollectionPublic {
    pub fun deposit(token: @NFT)
    pub fun getIDs(): [UInt64]
    pub fun borrowNFT(id: UInt64): &NFT
  }
  
  // This is a Collection and it allows us to store multiple resources in one storage path. 
  // It also has a resource interface `CollectionPublic` that requires the resource to have
  // 3 functions: deposit(), getIDs(), and borrowNFT()
  pub resource Collection: CollectionPublic {
    pub var ownedNFTs: @{UInt64: NFT}
    
    // Deposit function that deposits an NFT to our Collection
    pub fun deposit(token: @NFT) {
      self.ownedNFTs[token.id] <-! token
    }

    // Withdraw function that will withdraw an NFT from our Collection
    pub fun withdraw(withdrawID: UInt64): @NFT {
      let nft <- self.ownedNFTs.remove(key: withdrawID) 
              ?? panic("This NFT does not exist in this Collection.")
      return <- nft
    }
  
    // getIDs function that returns an array of NFT 
    // ids that are stored in our Collection
    pub fun getIDs(): [UInt64] {
      return self.ownedNFTs.keys
    }

    // borrowNFT function returns a reference to an
    // id of an NFT stored inside our Collection
    pub fun borrowNFT(id: UInt64): &NFT {
      return (&self.ownedNFTs[id] as &NFT?)!
    }

    // Initalizes ownedNFTs
    init() {
      self.ownedNFTs <- {}
    }

    // destroys ownedNFTs
    destroy() {
      destroy self.ownedNFTs
    }
  }

  // createEmptyCollection creates a new empty Collection 
  pub fun createEmptyCollection(): @Collection {
    return <- create Collection()
  }

  // This is a resource `Minter` that allows the account that holds the
  // resource to mint NFTs
  pub resource Minter {

    // createNFT function creates an NFT resource 
    pub fun createNFT(name: String, favouriteFood: String, luckyNumber: Int): @NFT {
      return <- create NFT(_name: name, _favouriteFood: favouriteFood, _luckyNumber: luckyNumber)
    }
    
    // createMinter function creates a Minter resource
    pub fun createMinter(): @Minter {
      return <- create Minter()
    }

  }
  
  // Initializing totalSupply and saves a Minter function to the account 
  // storage of the account deploying the contract
  init() {
    self.totalSupply = 0
    self.account.save(<- create Minter(), to: /storage/Minter)
  }
}
```
