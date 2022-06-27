## 1/100 Days of Cadence

### Contract that has 1 field and returns a resource
```cadence
pub contract Country {

    pub resource State {
        pub let name: String
        pub let capital: String

        init() {
            self.name = "New York"
            self.capital = "Albany"
        }
    }

    pub fun createState(): @State {
        return <- create State()
    }
    
    init() {
    
    }

}
```

### Transaction: Saves resource to account storage, loads the resource from account storage, logs a field inside the resource, and destroys the resource
```cadence
import Country from 0x01

transaction() {

  prepare(signer: AuthAccount) {
    let newState <- Country.createState()
    signer.save(<- newState, to: /storage/MyStates)
    
    let loadState <- signer.load<@Country.State>(from: /storage/MyStates)
                     ?? panic("No State Resource Found.")
    
    log(loadState.name)
    destroy loadState
  }

  execute {
  
  }

}

```

### Transaction: Saves resource to account storage, borrows a reference to the resource and logs a field inside the resource
```cadence
import Country from 0x01

transaction() {

   prepare(signer: AuthAccount) {
      let newState <- Country.createState()
      signer.save(<- newState, to: /storage/MyStates)
        
      let borrowState = signer.borrow<&Country.State>(from: /storage/MyStates)
          ?? panic("No State Resource Found.")

      log(borrowState.capital)
  }

}
```
