## Day 18/100 Days of Cadence

### Fungible Tokens - [Fungible Token Standard](https://github.com/onflow/flow-ft)
* Transfer transaction used to deposit and withdraw tokens with a `Vault`
```cadence
import TokenContract from 0x01

transaction {
  
  prepare(signer: AuthAccount) {
    
    let vaultReference = signer.borrow<&TokenContract.Vault>(from: /storage/VaultStorage)
    		?? panic("Could not borrow reference.")
    
    let tempVault <- vaultReference.withdraw(amount: 40.0)
    
    vaultReference.deposit(from: <-tempVault)
    
    log("Success 🎉")
    
  }
}
```
* Linking transaction - Create capability linked to an account's token vault
```cadence
import TokenContract from 0x01

transaction {
  
  prepare(signer: AuthAccount) {
    
    signer.link<&TokenContract.Vault{TokenContract.Receiver, TokenContract.Balance}>						
      (/public/PublicVaultStorage, target: /storage/VaultStorage)
    
    log("Reference Created")
  }
  
  // Postcondition - checks the Reciever capability was created correctly
  post {	
    getAccount(0x04).getCapability<&ExampleToken.Vault{ExampleToken.Receiver>
      (/public/CadenceFungibleTokenTutorialReceiver)                   
      .check():
       "Receiver reference was not created correctly"
  }
}
```
  
