## Day 9/100 Days of Cadence

### Chapter 5.0 Day 3 Quests - Cadence Bootcamp

1. What does "force casting" with as! do? Why is it useful in our Collection?

Force casting takes a generic type and downcast it to be a more specific type. Example: @NonFungibleToken.NFT is generic but when used with the force cast operator as! the type becomes @NFT which is a more specific type. It's useful in Collections because it makes sure that the correct token/nft is being deposited into the collection.

2. What does auth do? When do we use it?

auth is a keyword that is used with references to downcast. References need an "authorized reference" using auth before the reference being downcast. Example: let ref = (&self.ownedNFTs[id] as auth &NonFungibleToken.NFT?)!
