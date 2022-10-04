## Day 93/100 Days of Cadence

* Updated the resource interface in verify account setup script
```cadence
import Badger from 0x01
import NonFungibleToken from 0x02

pub fun main(account: Address): Bool {
    if getAccount(account).getCapability<&Badger.Collection{Badger.CollectionPublic}>(Badger.BadgerCollectionPublicPath).borrow() == nil {
        return false
    }
    return true
} 
```
* Created script to return the current supply of Badger
```cadence
import Badger from 0x01

pub fun main(): UInt64 {
    let totalSupply = Badger.totalSupply

    return totalSupply
}
```
* Worked on delete function and delete script error 
