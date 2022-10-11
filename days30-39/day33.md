## Day 33/100 Days of Cadence

### [Emerald City Dapp Course](https://github.com/emerald-dao/beginner-dapp-course)

**Chapter 3.0 Day 2 Quests**

1. **Explain why we wouldn't call changeGreeting in a script.**

    We wouldn't call `changeGreeting` in a script because scripts only read from the blockchain and the `changeGreeting` function changes data so it needs to be used in a transaction. 

2. **What does the AuthAccount mean in the prepare phase of the transaction?**

    `AuthAccount` is used to access the data in your account when you sign a transaction. 

3. **What is the difference between the prepare phase and the execute phase in the transaction?**

    The `prepare` phase can access your account data and the `execute` phase can call functions and change data on the blockchain, but the `execute` phase cannot access your account data.

4. **Update your contract, script, & transaction**

    * Add two new things inside your contract:
      * A variable named `myNumber` that has type `Int` (set it to 0 when the contract is deployed)
      * A function named `updateMyNumber` that takes in a new number named `newNumber` as a parameter that has type `Int` and updates `myNumber` to be `newNumber`
     
    ![myNumberVarible](https://github.com/AmethystCodes/ec-beginner-dapp-course/blob/main/images/update-contract.png)

    * Add a script that reads `myNumber` from the contract

    ![Cadence Script](https://github.com/AmethystCodes/ec-beginner-dapp-course/blob/main/images/myNumber-script.png)

    * Add a transaction that takes in a parameter named `myNewNumber` and passes it into the `updateMyNumber` function. Verify that your number changed by running the script again.
    
    ![Cadence Transaction](https://github.com/AmethystCodes/ec-beginner-dapp-course/blob/main/images/myNewNumber-transaction.png)
    ![Cadence Script](https://github.com/AmethystCodes/ec-beginner-dapp-course/blob/main/images/verifyNumber-script.png)
