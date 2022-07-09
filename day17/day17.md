## Day 17/100 Days of Cadence

Script to read a specific NFT's metadata from an address with `borrowAuthNFT()` from Day 16 contract:
```cadence
import NonFungibleToken from 0x01
import MyNFTCollection from 0x02

pub fun main(address: Address, id: UInt64): &MyNFTCollection.NFT {
    let publicCollection = getAccount(address).getCapability(/public/MyNFTCollection)
                            .borrow<&MyNFTCollection.Collection{MyNFTCollection.ICollection}>()
                            ?? panic("Collection cannot be accessed.")
    
    return publicCollection.borrowAuthNFT(id: id)
}
```

Script to read GoatedGoats `totalSupply`:
```cadence
import GoatedGoats from 0x2068315349bdfce5
pub fun main(): UInt64 {
  let supply = GoatedGoats.totalSupply

  return supply
}
```
Script to read GoatedGoats `getIDs`:
```cadence
import GoatedGoats from 0x2068315349bdfce5

pub fun main(address: Address): [UInt64] {
  let goatedGoatsCollection = getAccount(address).getCapability(GoatedGoats.CollectionPublicPath)
                                .borrow<&GoatedGoats.Collection{GoatedGoats.GoatCollectionPublic}>()
                                ?? panic("Address does not have a Goated Goats Collection")
  return goatedGoatsCollection.getIDs()
}
```
