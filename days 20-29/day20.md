## Day 20/100 Days of Cadence

Continued working through the buildspace Flow NFT project. Added some additional scripts to the React.

* Minting transaction within React App
```cadence
export const mintNFT = 
`
import ContractName from 0x01 

import NonFungibleToken from 0x631e88ae7f1d7c20
import MetadataViews from 0x631e88ae7f1d7c20

transaction(
  recipient: Address,
  name: String,
  description: String,
  thumbnail: String,
) {
  prepare(signer: AuthAccount) {
    if signer.borrow<&ContractName.Collection>(from: ContractName.CollectionStoragePath) != nil {
      return
    }

    // Create a new empty collection
    let collection <- ContractName.createEmptyCollection()

    // save it to the account
    signer.save(<-collection, to: ContractName.CollectionStoragePath)

    // create a public capability for the collection
    signer.link<&{NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection}>(
      ContractName.CollectionPublicPath,
      target: ContractName.CollectionStoragePath
    )
  }


  execute {
    // Borrow the recipient's public NFT collection reference
    let receiver = getAccount(recipient)
      .getCapability(ContractName.CollectionPublicPath)
      .borrow<&{NonFungibleToken.CollectionPublic}>()
      ?? panic("Could not get receiver reference to the NFT Collection")

    // Mint the NFT and deposit it to the recipient's collection
    ContractName.mintNFT(
      recipient: receiver,
      name: name,
      description: description,
      thumbnail: thumbnail,
    )
    
    log("Minted an NFT and stored it into the collection")
  } 
}
`
```

* Adding a `getIDs` script to the React App
```cadence
export const getIDs = `
import MetadataViews from 0x631e88ae7f1d7c20;

pub fun main(address: Address): [UInt64] {
    
  let account = getAccount(address)

  let collection = account
    .getCapability(/public/ContractNameCollection)
    .borrow<&{MetadataViews.ResolverCollection}>()
    ?? panic("Could not borrow a reference to the collection")

  let IDs = collection.getIDs()
  return IDs;
}
`;
```
