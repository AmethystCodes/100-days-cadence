## Day 30/100 Days of Cadence

### [Emerald City Dapp Course](https://github.com/emerald-dao/beginner-dapp-course)

**Chapter 2.0 Day 3 Quests**

**1. In this part, we will be adding another button and changing up some styling.**
* Wrap the <button> tag we added inside of a `<div>`. Add a className called `styles.flex` to that `<div>`. Make sure the `<button>` is inside of it.
* Then, add another `<button>` inside the `<div>` tag and put "Goodbye" inside of it.
* In `./styles/Home.module.css`, add a new style for the "flex" class, and inside of it, add one line: `display: flex`
  
**2. Now we're going to add an action to your new button.**
* To your second button, add an `onClick` handler and call a function named `printGoodbye`.
* Define a new function called `printGoodbye` under the `printHello` function
* Make it console.log "Goodbye"
  
**Take a picture of both the screen and the console logs in the developer console**
  
![OnClick](https://github.com/AmethystCodes/ec-beginner-dapp-course/blob/main/images/add-buttons.png)
