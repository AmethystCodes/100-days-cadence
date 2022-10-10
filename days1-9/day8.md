## Day 8/100 Days of Cadence

### Chapter 5.0 Day 2 Quests

**1. Explain why standards can be beneficial to the Flow ecosystem.**

Standards are beneficial to the Flow ecosystem because it eliminates having to implement different functionality for every contract. It also helps clients understand what type of contract they are dealing with. 

**2. What is YOUR favourite food?**

🎂🍰

**3. Please fix this code (Hint: There are two things wrong):**

Contract Interface:
```cadence
pub contract interface ITest {
  pub var number: Int
  
  pub fun updateNumber(newNumber: Int) {
    pre {
      newNumber >= 0: "We don't like negative numbers for some reason. We're mean."
    }
    post {
      self.number == newNumber: "Didn't update the number to be the new number."
    }
  }

  pub resource interface IStuff {
    pub var favouriteActivity: String
  }

  pub resource Stuff {
    pub var favouriteActivity: String
  }
}
```
Implementing contract:

  * Add contract interface `ITest` to `pub contract Test`
  * Add contract interface `ITest.IStuff` to the resource `pub resource Stuff`
  * Remove resource interface `Stuff`
  * Import ITest
```cadence
import ITest from 0x01
pub contract Test: ITest // Add contract interface {
  pub var number: Int
  
  pub fun updateNumber(newNumber: Int) {
    self.number = newNumber
  }

  pub resource Stuff: ITest.IStuff // Add the contract interface {
    pub var favouriteActivity: String

    init() {
      self.favouriteActivity = "Playing League of Legends."
    }
  }

  init() {
    self.number = 0
  }
}
```
