## Day 6/100 Days of Cadence

### Chapter 5.0 Day 1 Quests - Cadence Bootcamp

**1. Describe what an event is, and why it might be useful to a client.**

An event is used to communicate that something has occurred with the smart contract. A client will find events useful because they will know an event occurred and can update their code. 

**2. Deploy a contract with an event in it, and emit the event somewhere else in the contract indicating that it happened.**

```cadence
pub contract HappyBirthday {

  pub event BirthdayCakeMinted(id: UInt64, message: String, candles: Int)
  
  pub resource BirthdayCake {
    pub let id: UInt64
    pub var message: String
    pub var candles: Int     

    init() {
      self.id = self.uuid
      self.message = "Happy 🎂 Birthday"
      self.candles = 0

      emit BirthdayCakeMinted(id: self.id, message: self.message, candles: self.candles)
    }
    
  }
  
  pub fun createBirthdayCake(): @BirthdayCake {
    return <- create BirthdayCake()
  }
  
  init() {}
  
}
```

**3. Using the contract in step 2), add some pre conditions and post conditions to your contract to get used to writing them out.**

```cadence
pub contract HappyBirthday {

  pub event BirthdayCakeMinted(id: UInt64, message: String, candles: Int)
  
  pub resource BirthdayCake {
    pub let id: UInt64
    pub var message: String
    pub var candles: Int
    
    pub fun changeBirthdayMessage(newMessage: String) {
      pre {
        newMessage.length > 0: "Add new Birthday message 🎉"
      }
      self.message = newMessage
    } 

    pub fun addCandles(numberOfCandles: Int): Int {
      post {
        result >= 1: "Add more candles"
      }
       return self.candles + numberOfCandles
    }       

    init() {
      self.id = self.uuid
      self.message = "Happy 🎂 Birthday"
      self.candles = 0

      emit BirthdayCakeMinted(id: self.id, message: self.message, candles: self.candles)
    }
    
  }
  
  pub fun createBirthdayCake(): @BirthdayCake {
    return <- create BirthdayCake()
  }
  
  init() {}
  
}
```

**4. For each of the functions below (numberOne, numberTwo, numberThree), follow the instructions.**

  * numberOne() will log the name because it is 5 characters long.
  * numberTwo() will return a value because it meets both pre and post conditions.
  * numberThree() will not log the updated number; `self.number` resets to 0 because the pre-condition is not satisfied and aborts.

```cadence
pub contract Test {

  // TODO
  // Tell me whether or not this function will log the name.
  // name: 'Jacob'
  
  pub fun numberOne(name: String) {
    pre {
      name.length == 5: "This name is not cool enough."
    }
    log(name)
  }

  // TODO
  // Tell me whether or not this function will return a value.
  // name: 'Jacob'
  
  pub fun numberTwo(name: String): String {
    pre {
      name.length >= 0: "You must input a valid name."
    }
    post {
      result == "Jacob Tucker"
    }
    return name.concat(" Tucker")
  }

  pub resource TestResource {
    pub var number: Int

    // TODO
    // Tell me whether or not this function will log the updated number.
    // Also, tell me the value of `self.number` after it's run.
    
    pub fun numberThree(): Int {
      post {
        before(self.number) == result + 1
      }
      self.number = self.number + 1
      return self.number
    }

    init() {
      self.number = 0
    }

  }

}
```
