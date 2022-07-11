## Day 19/100 Days of Cadence

### Fungible Tokens - Transferring tokens and checking account balances

* Transaction that will tranfer tokens to another user
```cadence

import TokenContract from 0x01

transaction {

  // Temporary vault that holds the balance being transferred
  var tempVault: @TokenContract.Vault
  
  prepare(signer: AuthAccount) {
    // Borrows a reference from the public capability
    let vaultReference = acct.borrow<&TokenContract.Vault>(from: /storage/FungibleTokenStorage)
          ?? panic("Could not borrow reference")
    
    self.tempVault <- vaultReference.withdraw(amount: 5.0)
  }
  execute {
    let recipient = getAccount(0x05)
    
    let recipientRef = recipient.getCapability(/public/FungibleTokenReceiverStorage)
                        .borrow<&TokenContract.Vault{TokenContract.Receiver}>()
                        ?? panic("Could not borrow reference.")
                        
    // Deposits tokens into their Vault
    recipientRef.deposit(from: <- self.tempVault)
    
    log("Transfer successful!")
  } 
}
```

* Script that reads an account's balance
```cadence
import FungibleToken from 0x01

pub fun main() {
  let account = getAccount(0x03)
  
  // Create reference to the account's receivers using a capability
  let accountReceiverRef = account.getCapability(/public/FungibleTokenReceiverStorage)
                            .borrow<&FungibleToken.Vault{FungibleToken.Balance}>()
                            ?? panic("Could not borrow reference for account.")
  log("Account Balance:")
  log(accountReceiverRef.balance)
}
```
