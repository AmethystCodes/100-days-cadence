## Day 10/100 Days of Cadence

### Chapter 5 Day 3 Quests (cont) - Cadence Bootcamp

**3. Take this contract and add a function called borrowAuthNFT. Then make it publically accessible to other people so they can read our NFT's metadata. Then, run a script to display the NFTs metadata for a certain id**

* Add a function called borrowAuthNFT
```cadence
import NonFungibleToken from 0x02
pub contract CryptoPoops: NonFungibleToken {
  pub var totalSupply: UInt64

  pub event ContractInitialized()
  pub event Withdraw(id: UInt64, from: Address?)
  pub event Deposit(id: UInt64, to: Address?)

  pub resource NFT: NonFungibleToken.INFT {
    pub let id: UInt64

    pub let name: String
    pub let favouriteFood: String
    pub let luckyNumber: Int

    init(_name: String, _favouriteFood: String, _luckyNumber: Int) {
      self.id = self.uuid

      self.name = _name
      self.favouriteFood = _favouriteFood
      self.luckyNumber = _luckyNumber
    }
  }
  
  pub resource interface ICollection {
    pub fun borrowAuthNFT(id: UInt64): &NFT
  }

  pub resource Collection: NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic {
    pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

    pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
      let nft <- self.ownedNFTs.remove(key: withdrawID) 
            ?? panic("This NFT does not exist in this Collection.")
      emit Withdraw(id: nft.id, from: self.owner?.address)
      return <- nft
    }

    pub fun deposit(token: @NonFungibleToken.NFT) {
      let nft <- token as! @NFT
      emit Deposit(id: nft.id, to: self.owner?.address)
      self.ownedNFTs[nft.id] <-! nft
    }

    pub fun getIDs(): [UInt64] {
      return self.ownedNFTs.keys
    }

    pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
      return (&self.ownedNFTs[id] as &NonFungibleToken.NFT?)!
    }

    pub fun borrowAuthNFT(id: UInt64): &NFT {
      let ref = (&self.ownedNFTs[id] as auth &NonFungibleToken.NFT?)!
      return ref as! &NFT
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

    pub fun createNFT(name: String, favouriteFood: String, luckyNumber: Int): @NFT {
      return <- create NFT(_name: name, _favouriteFood: favouriteFood, _luckyNumber: luckyNumber)
    }

    pub fun createMinter(): @Minter {
      return <- create Minter()
    }

  }

  init() {
    self.totalSupply = 0
    emit ContractInitialized()
    self.account.save(<- create Minter(), to: /storage/Minter)
  }
}
```
* Make borrowAuthNFT publically accessible
```cadence
pub resource interface ICollection {
    pub fun borrowAuthNFT(id: UInt64): &NFT
  }
  
// Add ICollection interface to `pub resource Collection: ..., ICollection {}`
Create Collection
import NonFungibleToken from 0x02
import CryptoPoops from 0x03

transaction() {

    prepare(signer: AuthAccount) {
        signer.save(<- CryptoPoops.createEmptyCollection(), to: /storage/CryptoPoopsCollection)
        signer.link<&CryptoPoops.Collection{NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, CryptoPoops.ICollection}>(/public/CryptoPoopsCollection, target: /storage/CryptoPoopsCollection)
    }

    execute {
        log("CryptoPoops Collection saved to storage.")
    }
}
```
* Mint NFT - Must be signed by the account that deployed the contract
```cadence
import NonFungibleToken from 0x02
import CryptoPoops from 0x03

transaction(recipient: Address, name: String, favouriteFood: String, luckyNumber: Int) {
  
    prepare(signer: AuthAccount) {
        let minter = signer.borrow<&CryptoPoops.Minter>(from: /storage/Minter)
                        ?? panic("This signer is not the one who deployed the contract.")
        
        let recipientsCollection = getAccount(recipient).getCapability(/public/CryptoPoopsCollection)
                                        .borrow<&CryptoPoops.Collection{NonFungibleToken.CollectionPublic}>()
                                        ?? panic("Recipient does not have a Collection.")

        let nft <- minter.createNFT(name: name, favouriteFood: favouriteFood, luckyNumber: luckyNumber)
    
        recipientsCollection.deposit(token: <- nft)
    }

    execute {
        log("NFT was minted 🎉")
    }
}
```

* Script to display getIDs()
```cadence
import CryptoPoops from 0x03
import NonFungibleToken from 0x02

pub fun main(address: Address): [UInt64] {
  let publicCollection = getAccount(address).getCapability(/public/CryptoPoopsCollection)
                .borrow<&CryptoPoops.Collection{NonFungibleToken.CollectionPublic}>()
                ?? panic("The address does not have a Collection.")

  return publicCollection.getIDs()
}
```

* Run a script to display the NFTs metadata for a certain id
```cadence
import CryptoPoops from 0x03
import NonFungibleToken from 0x02

pub fun main(address: Address, id: UInt64): &CryptoPoops.NFT {
    let publicCollection = getAccount(address).getCapability(/public/CryptoPoopsCollection)
                            .borrow<&CryptoPoops.Collection{CryptoPoops.ICollection}>()
                            ?? panic("Collection cannot be accessed.")
    
    return publicCollection.borrowAuthNFT(id: id)
}
```
