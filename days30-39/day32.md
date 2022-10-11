## Day 32/100 Days of Cadence

### [Secure Cadence Update](https://forum.onflow.org/t/breaking-changes-coming-with-secure-cadence-release/3052)
### [Emerald City Dapp Course](https://github.com/emerald-dao/beginner-dapp-course)

**Chapter 3.0 Day 1 Quests**

**1. Deploy a contract to account 0x03 called "JacobTucker". Inside that contract, declare a constant variable named is, and make it have type String. Initialize it to "the best" when your contract gets deployed.**

```cadence
pub contract JacobTucker {
  pub let is: String

  init() {
    self.is = "the best"
  }
}
```
**2. Check that your variable is actually equals "the best" by executing a script to read that variable. Include a screenshot of the output.**

![Reading a Script in Cadence](https://github.com/AmethystCodes/ec-beginner-dapp-course/blob/main/images/read-variable.png)
