# Day 2/100DaysOfCadence

Contract with a resource that implements a resource interface:
```cadence
pub contract Country {

    pub resource interface IState {
        pub var name: String
        pub var capital: String
        pub var population: Int
    }

    pub resource State: IState {
        pub var name: String
        pub var capital: String
        pub var stateBird: String
        pub var population: Int

        pub fun updatePopulation(newPopulation: Int): Int {
            self.population = newPopulation
            return self.population
        }

        init() {
            self.name = "New York"
            self.capital = "Albany"
            self.stateBird = "Eastern Bluebird"
            self.population = 19_510_000 
        }
    }

    pub fun createState(): @State {
        return <- create State()
    }

    init() {
    
    }

}
```

**Transaction:** Save a resource to storage and link it to public storage with the restrictive interface
```cadence
import Country from 0x01

transaction() {

  prepare(signer: AuthAccount) {
    signer.save(<- Country.createState(), to: /storage/MyStateResource)

    signer.link<&Country.State{Country.IState}>(/public/MyStateResource, target: /storage/MyStateResource)
  }

  execute {
  
  }

}
```
**Script:** Access `name` field from the resource interface and return it
```cadence
import Country from 0x01

pub fun main(address: Address): String {
  let stateCapability: Capability<&Country.State{Country.IState}> =
    getAccount(address).getCapability<&Country.State{Country.IState}>(/public/MyStateResource)

  let stateResource: &Country.State{Country.IState} = stateCapability.borrow() ?? panic("No State Resource Found.")

  return stateResource.name
}
```
