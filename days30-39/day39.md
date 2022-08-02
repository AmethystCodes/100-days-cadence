## Day 39/100 Days of Code

Adding a script with different types for arguments

```javascript

async function newScript() {
    const response = await fcl.query({
      cadence: `
      pub fun main(
        a: Int, 
        b: String, 
        c: UFix64, 
        d: Address, 
        e: Bool,
        f: String?,
        g: [Int],
        h: {String: Address}
      ): UFix64 {
        return c
      }
      `,
      args: (arg, t) => [
        arg("7", t.Int),
        arg("Hello Github", t.String),
        arg("73.0", t.UFix64),
        arg("0x01", t.Address),
        arg(false, t.Bool),
        arg(null, t.Optional(t.String)),
        arg([4, 2, 3], t.Array(t.Int)),
        arg(
          [
            { key: "FLOAT", value: "0x2d4c3caffbeab845" },
            { key: "EmeraldID", value: "0x39e42c67cc851cfb" }
          ], 
          t.Dictionary({ key: t.String, value: t.Address })
        )
      ]
    })
    console.log(response)
  }

  useEffect(() => {
    newScript()
  }, [])
  ```
  
  Adding a transaction that updates a number from a contract and then reads the number from the same contract.
  
  ```javascript
  async function updateNumber() {
    const transactionId = await fcl.mutate({
      cadence: `
      import SimpleTest from 0x6c0d53c676256e8c
 
      transaction(myNewNumber: Int) {
       
        prepare(signer: AuthAccount) {}
         
        execute {
          SimpleTest.updateNumber(newNumber: myNewNumber)
        }
      }
      `,
      args: (arg, t) => [
        arg(newNumber, t.Int)
      ],
      proposer: fcl.authz,
      payer: fcl.authz,
      authorization: [fcl.authz],
      limit: 999
    })
 
    console.log("Here is the transactionId: " + transactionId);
 
    await fcl.tx(transactionId).onceSealed();
    readNumber(); // Result 44
  }
 
  async function readNumber() {
    const response = await fcl.query({
      cadence: `
      import SimpleTest from 0x6c0d53c676256e8c
 
      pub fun main(): Int {
        return SimpleTest.number
      }
      `,
      args: (arg, t) => []
    })
 
    setNewNumber(response)
    console.log(response)
  }
 
  useEffect(() => {
    readNumber()
  }, [])
  ```
