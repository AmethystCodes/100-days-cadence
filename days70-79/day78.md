## Day 78/100 Days of Cadence

* Updated Contract with Collection, functions and total supply
```cadence
pub contract StreakTracker {

    pub var totalSupply: UInt64

    pub resource interface IStreak {
        pub let id: UInt64
        pub let name: String
        pub let daysCompleted: UInt64
        pub var quote: String
    }

    pub resource Streak: IStreak {
        pub let id: UInt64
        pub let name: String
        pub let daysCompleted: UInt64
        pub var quote: String

        pub fun changeQuote(newQuote: String) {
            self.quote = newQuote
        }

        init(name: String, daysCompleted: UInt64, quote: String) {
            self.id = self.uuid
            self.name = name
            self.daysCompleted = daysCompleted
            self.quote = quote
        } 
    }

    pub fun createStreak(name: String, daysCompleted: UInt64, quote: String): @Streak {
        return <- create Streak(name: name, daysCompleted: daysCompleted, quote: quote)
    }

    pub resource Collection {
        pub var ownedNFTs: @{UInt64: Streak}

        pub fun deposit(token: @Streak) {
            self.ownedNFTs[token.id] <-! token
        }

        pub fun withdraw(withdrawID: UInt64): @Streak {
            let nft <- self.ownedNFTs.remove(key: withdrawID)
                ?? panic("This NFT does not exist in the Collection")
            return <- nft
        }

        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        init() {
            self.ownedNFTs <- {}
        }

        destroy() {
            destroy self.ownedNFTs
        }
    }

    pub fun createEmptyCollection(): @Collection {
        return <- create Collection()
    }

    init() {
        self.totalSupply = 0
    }
}
```

* Transaction to save a resource to an account and link it to public storage
```cadence
import StreakTracker from 0x01

transaction(name: String, daysCompleted: UInt64, quote: String) {

  prepare(acct: AuthAccount) {
    acct.save(<- StreakTracker.createStreak(name: name, daysCompleted: daysCompleted, quote: quote), to: /storage/StreakTrackerCollection)
    acct.link<&StreakTracker.Streak{StreakTracker.IStreak}>(/public/StreakTrackerCollectionPublic, target: /storage/StreakTrackerCollection)
  }

  execute {

  }
}


```

* Script to read exposed fields
```cadence
import StreakTracker from 0x01

pub fun main(address: Address): String {
  let publicCapability: Capability<&StreakTracker.Streak{StreakTracker.IStreak}> =
    getAccount(address).getCapability<&StreakTracker.Streak{StreakTracker.IStreak}>(/public/StreakTrackerCollectionPublic)

  let resource: &StreakTracker.Streak{StreakTracker.IStreak} = publicCapability.borrow()
        ?? panic("Capability does not exist ")
  return resource.name
}
```
