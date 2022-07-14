// mintToken.cdc

import Tamagotchi from 0x01

transaction(metadata: {String: String}) {

    // Declare "unauthorized" reference to `INFT` interface
    let receiverRef: &{Tamagotchi.INFT}

    // Declare an "authorized" reference to the `Minter` interface
    let minterRef: &Tamagotchi.Minter

    prepare(signer: AuthAccount) {
    
        // For an unauthorized reference, need to `.getCapability` followed
        // by `.borrow()` 
        self.receiverRef = signer.getCapability<&{Tamagotchi.INFT}>(Tamagotchi.CollectionPublicPath)
            .borrow() ?? panic("Could not borrow Receiver reference")

        // Authorized references can just `.borrow()` from `/storage/`
        self.minterRef = signer.borrow<&Tamagotchi.Minter>(from: Tamagotchi.MinterStoragePath)
            ?? panic("Could not borrow Minter reference")
    }

    execute {

        // Mint token by calling `mint(metadata: {String: String})`
        // from `Minter` resoure
        let newToken <- self.minterRef.mint(metadata)

        // Call `deposit(token: @NFT)` to deposit the token.
        // Where the metadata can be changed before transferring 
        self.receiverRef.deposit(token: <- newToken)
    }

}
