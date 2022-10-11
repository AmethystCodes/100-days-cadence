## Day 37/100 Days of Cadence

### [Emerald City Dapp Course](https://github.com/emerald-dao/beginner-dapp-course)

**Chapter 4.0 Day 1 Quests**

**1. How did we get the address of the user? Please explain in words and then in code.**
 
The address of the user is stored in the `user` variable when the user clicks the log in button.  
```javascript
<button onClick={handleAuthentication}>{user.loggedIn ? user.addr : "Log In"}</button>
```
 
**2. What do `fcl.authenticate` and `fcl.unauthenticate` do?**

`fcl.authenticate` = logs user in
 
`fcl.unauthenticate` = logs user out

 
**3. Why did we make a `config.js` file? What does it do?**

The config file tells the DApp what network to communicate with, in this case, it’s testnet. It also sets up a wallet connection so that users can log into the application using different wallets, like Blocto and Lilico. 
 
**4. What does our `useEffect` do?**

Our `useEffect` runs: fcl.currentUser.subscribe(setUser); and it makes sure that the variable `user` maintains its value even if the page is reloaded. 
 
**5. How do we import FCL?**
```javascript
import * from “@onflow/fcl”;
```
 
**6. What does `fcl.currentUser.subscribe(setUser);` do?**

Sets the `user` to the currentUser
