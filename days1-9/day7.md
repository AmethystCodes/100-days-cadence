## Day 7/100 Days of Cadence

### Chapter 5 Day 1 Quests (cont) - Cadence Bootcamp

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
