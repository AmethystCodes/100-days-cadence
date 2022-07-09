## Day 16/100 Days of Cadence

Created an NFT contract and deployed to testnet:
```cadence

import NonFungibleToken from 0x01

pub contract MyNFTCollection: NonFungibleToken {
  pub var totalSupply: UInt64

  pub event ContractInitialized()
  pub event Withdraw(id: UInt64, from: Address?)
  pub event Deposit(id: UInt64, to: Address?)

  pub resource NFT: NonFungibleToken.INFT {
    pub let id: UInt64

    pub let name: String
    pub let favouriteColor: String
    pub let luckyNumber: Int

    init(_name: String, _favouriteColor: String, _luckyNumber: Int) {
      self.id = self.uuid

      self.name = _name
      self.favouriteColor = _favouriteColor
      self.luckyNumber = _luckyNumber
    }
  }
  
  pub resource interface ICollection {
    pub fun borrowAuthNFT(id: UInt64): &NFT
  }

  pub resource Collection: NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, ICollection {
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

    pub fun createNFT(name: String, favouriteColor: String, luckyNumber: Int): @NFT {
      MyNFTCollection.totalSupply = MyNFTCollection.totalSupply + 1
      return <- create NFT(_name: name, _favouriteColor: favouriteColor, _luckyNumber: luckyNumber)
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
Transaction that mints an NFT from a contract:
```cadence
import NonFungibleToken from 0x01
import MyNFTCollection from 0x02

transaction(recipient: Address, name: String, favouriteColor: String, luckyNumber: Int) {
  
    prepare(signer: AuthAccount) {
        let minter = signer.borrow<&MyNFTCollection.Minter>(from: /storage/Minter)
                        ?? panic("This signer is not the one who deployed the contract.")
        
        let recipientsCollection = getAccount(recipient).getCapability(/public/MyNFTCollection)
                                        .borrow<&MyNFTCollection.Collection{NonFungibleToken.CollectionPublic}>()
                                        ?? panic("Recipient does not have a Collection.")

        let nft <- minter.createNFT(name: name, favouriteColor: favouriteColor, luckyNumber: luckyNumber)
    
        recipientsCollection.deposit(token: <- nft)
    }

    execute {
        log("NFT was minted 🎉")
    }
}
```
Script to read new totalSupply for contract after minting:
```cadence
import BalloonBuddies from 0x02
pub fun main(): UInt64 {
  let supply = MyNFTCollection.totalSupply

  return supply
}
```

