## Day 34/100 Days of Cadence

### [Emerald City Dapp Course](https://github.com/emerald-dao/beginner-dapp-course)

**Chapter 3.0 Day 3 Quests**
 
**1. Create a new smart contract in Cadence that has at least the following two things:**
* A variable to hold a value (like a number or a piece of text)
* A function to change that variable
```cadence
pub contract Fruit {
  pub var name: String
 
  pub fun changeFruit(newFruit: String) {
    self.name = newFruit
  }
 
  init() {
    self.name = "Mango"
  }
}
```
 
After, deploy that contract to the same testnet account you generated today.
 
**2. Send a screenshot of you reading the variable from your new contract using the Flow CLI**

![readFruit](https://github.com/AmethystCodes/ec-beginner-dapp-course/blob/main/images/readFruit.png)

**3. Send a screenshot of you changing the variable from your new contract using the Flow CLI**

![changeFruit](https://github.com/AmethystCodes/ec-beginner-dapp-course/blob/main/images/changeFruit.png)
**4. Send a screenshot of you reading your changed variable from your new contract using the Flow CLI**

![readUpdatedFruit](https://github.com/AmethystCodes/ec-beginner-dapp-course/blob/main/images/readFruitUpdated.png)

**5. Go to https://flow-view-source.com/testnet/. Where it says "Account", paste in the Flow address you generated and click "Go". On the left hand side, you should see your "HelloWorld" contract and your new contract. Isn't it so cool to see them live on Testnet? Then, send the URL to the page.**
 
💎[Testnet Contract](https://flow-view-source.com/testnet/account/0xe5ac316a97a507dc)💎
