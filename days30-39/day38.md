## Day 38/100 Days of Cadence

Adding scripts and arguments using FCL

```javascript
// Adding scripts and arguments using FCL

async function yourScript() {
  const response = await fcl.query({
    cadence: `
    // Insert your Cadence script here - Backticks surround your code
    
    import ContractName from 0x01 // Change to the correct address

    pub fun main(a: Int, b: Int): Int {
        return ContractName.result
    }
    `,
    args: (arg, t) => [
      // Add arguments here - syntax: arg(argument, t.type)
      arg("6", t.Int),
      arg("8", t.Int) 
    ] 
  }) 
}
```
