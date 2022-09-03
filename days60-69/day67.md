## Day 67/100 Days of Cadence

[Flow Fungible Token Tutorial](https://developers.flow.com/cadence/tutorial/06-fungible-tokens)

* Fungible Token Contract Example
```cadence
pub contract CadenceToken {
    
    // Users store an instance of the Valut in their storage
    pub resource Vault {

		// keeps track of the total balance of the account's tokens
        pub var balance: UFix64

        // initialize the balance at resource creation time
        init(balance: UFix64) {
            self.balance = balance
        }
        
        // Withdraw Function
        pub fun withdraw(amount: UFix64): @Vault {
            self.balance = self.balance - amount
            return <-create Vault(balance: amount)
        }

       // Deposit Function
        pub fun deposit(from: @Vault) {
            self.balance = self.balance + from.balance
            destroy from
        }
    }

    // Creates a new Vault with a balance of 50
    pub fun createVault(): @Vault {
        return <-create Vault(balance: 50.0)
    }
    
    init() {
        // Creates a Vault and saves it to
        // the user's account storage path
        let vault <- self.createVault()
        self.account.save(<-vault, to: /storage/CadenceFungibleTokenVault)
    }
}


```

* Transfer tokens to another user
```cadence

// Transfer Tokens

import CadenceToken from 0x02

transaction {

  // Temporary Vault object that holds the balance that is being transferred
  var temporaryVault: @CadenceToken.Vault

  prepare(acct: AuthAccount) {
    // withdraw tokens from your vault by borrowing a reference to it
    // and calling the withdraw function with that reference
    let vaultRef = acct.borrow<&CadenceToken.Vault>(from: /storage/CadenceFungibleTokenVault)
        ?? panic("Could not borrow a reference to the owner's vault")
      
    self.temporaryVault <- vaultRef.withdraw(amount: 10.0)
  }

  execute {
    // get the recipient's public account object
    let recipient = getAccount(0x02)

    // get the recipient's Receiver reference to their Vault
    // by borrowing the reference from the public capability
    let receiverRef = recipient.getCapability(/public/CadenceFungibleTokenReceiver)
                      .borrow<&CadenceToken.Vault{CadenceToken.Receiver}>()
                      ?? panic("Could not borrow a reference to the receiver")

    // deposit your tokens to their Vault
    receiverRef.deposit(from: <-self.temporaryVault)

    log("Transfer succeeded!")
  }
}
```

* Check account balances
```cadence
// Get Balances

import CadenceToken from 0x02

// This script reads the Vault balances of two accounts.
pub fun main() {
    let acct = getAccount(0x02)

    // Get references to the account's receivers
    // by getting their public capability
    // and borrowing a reference from the capability
    let acctReceiverRef = acct2.getCapability(/public/CadenceFungibleTokenReceiver)
                            .borrow<&CadenceToken.Vault{CadenceToken.Balance}>()
                            ?? panic("Could not borrow a reference to the acct2 receiver")
 

    // Log the Balance
    log("Account 2 Balance")
	  log(acctReceiverRef.balance)   
}

```
