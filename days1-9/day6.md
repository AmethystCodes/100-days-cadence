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
