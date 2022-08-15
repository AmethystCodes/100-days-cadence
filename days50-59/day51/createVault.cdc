// Transaction creating an empty vault and linking it to `/public/Vault`

import DigitalGold from 0x01
import FungibleToken from 0x02

transaction() {

  prepare(acct: AuthAccount) {
    acct.save(<- DigitalGold.createEmptyVault(), to: /storage/Vault)
    acct.link<&DigitalGold.Vault{FungibleToken.Balance, FungibleToken.Receiver}>(/public/Vault, target: /storage/Vault)
  }

  execute {
    log("Vault Created!")
  }
}
