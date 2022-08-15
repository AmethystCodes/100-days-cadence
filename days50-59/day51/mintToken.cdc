// Transaction that mints a token and deposits the token into the receivers account

import DigitalGold from 0x01
import FungibleToken from 0x02

transaction(receiverAcct: Address) {

  prepare(acct: AuthAccount) {
    let minter = acct.borrow<&DigitalGold.Minter>(from: /storage/Minter) 
                    ?? panic("Could not borrow Minter resource")

    let newVault <- minter.mintToken(amount: 45.0)
    
    let receiverVault = getAccount(receiverAcct).getCapability(/public/Vault)
                          .borrow<&DigitalGold.Vault{FungibleToken.Receiver}>()
                          ?? panic("Could not get the public vault")

    receiverVault.deposit(from: <- newVault)
  }

  execute {
    log("Deposited tokens into the receiver account.")
  }
}
