## Day 55/100 Days of Cadence

### 🛠️ Build on Flow | Learn FCL

[Build on Flow | Learn FCL: Pass Arguments to Scripts](https://dev.to/onflow/build-on-flow-learn-fcl-2-pass-arguments-to-scripts-393f)

[Build on Flow | Learn FCL: How to Return Custom Value from Script](https://dev.to/onflow/build-on-flow-learn-fcl-3-how-to-return-custom-value-from-script-3fp6)

* Pass Arguments to Scripts

```cadence
// Import query & config
import { query, config } from "@onflow/fcl";

// FCL needs to know where to send that script for execution
config().put("accessNode.api", "https://rest-testnet.onflow.org");

const passIntegers = async () => {
  // Here we will store the code we want to execute.
  // We can inline it into the object we pass to "query" method,
  // but it feels cleaner this way
  const cadence = `
    pub fun main(a: Int, b: Int): Int{
      return a + b
    }
  `;

  // Even though both of the arguments are numbers, we need to pass them as strings representation
  const a = (7).toString();
  const b = (11).toString();
  const args = (arg, t) => [arg(a, t.Int), arg(b, t.Int)];

  // "query" will pass Cadence code and arguments to access node for execution and return us a result:
  // read more about "query" method on Flow Docs Site:
  // https://docs.onflow.org/fcl/reference/api/#query
  const result = await query({ cadence, args });
  console.log({ result }); //
  showResult("int", result);
};

const passMultipleDifferentTypes = async () => {
  const cadence = `
    pub fun main(a: String, b: Bool, c: UFix64, d: Address): Bool {
      return b
    }
  `;

  // Addresses and numbers need to be passed as String values
  const a = "Learning Cadence";
  const b = true;
  const c = "42.0";
  const d = "0x01";

  // Types should always mirror argument types defined in script
  const args = (arg, t) => [
    arg(a, t.String),
    arg(b, t.Bool),
    arg(c, t.UFix64),
    arg(d, t.Address)
  ];

  const result = await query({ cadence, args });
  console.log({ result }); //
  showResult("multiple", result);
};

const passArray = async () => {
  const cadence = `
    pub fun main(a: [String]): String {
      return a[1]
    }
  `;

  const a = ["Hello", "Cadence"];
  // Type of the argument is composed of t.Array and t.String
  const args = (arg, t) => [arg(a, t.Array(t.String))];

  const result = await query({ cadence, args });
  console.log({ result }); //
  showResult("first", result);
};

const passDictionary = async () => {
  // In this example we will pass to Cadence Dictionary as argument
  // keys will be of type "String" and values of type "Int"
  const cadence = `
    pub fun main(a: {String: Int}): Int?{
      return a["amount"]
    }
  `;

  // Dictionaries should be represented as array of key/value pairs of respective types
  // Note that we shall pass numeric value as string here
  const a = [{ key: "amount", value: "42" }];
  // Dictionary type is composed out of t.Dictionary, t.String and t.Int for our case
  const args = (arg, t) => [
    arg(a, t.Dictionary({ key: t.String, value: t.Int }))
  ];

  const result = await query({ cadence, args });
  console.log({ result }); //
  showResult("field", result);
};

const passComplex = async () => {
  // In this example we will pass an Array of Dictionaries as argument
  // Keys will be of type "String" and values of type "Int"
  const cadence = `
    pub fun main(a: [{String: Int}]): Int?{
      return a[0]["amount"]
    }
  `;

  // Array of Dictionaries should be represented as array of arrays of key/value pairs of respective types
  // Note that we shall pass numeric value as string here
  const a = [[{ key: "amount", value: "1337" }]];
  // Dictionary type is composed out of t.Dictionary, t.String and t.Int for our case
  const args = (arg, t) => [
    arg(a, t.Array(t.Dictionary({ key: t.String, value: t.Int })))
  ];

  const result = await query({ cadence, args });
  console.log({ result });
  showResult("complex", result);
};

// We will use IIFE to execute our code right away
(async () => {
  console.clear();
  showResultBlock();

  await passIntegers();
  await passMultipleDifferentTypes();
  await passArray();
  await passDictionary();
  await passComplex();
})();

```

* How to Return Custom Value from Script

```cadence
// Import query & config
import { query, config } from "@onflow/fcl";

// FCL needs to know where to send that script for execution
// This time we will point FCL to mainnet
config().put("accessNode.api", "https://rest-mainnet.onflow.org");

const fetchCustom = async (name) => {
  const cadence = `
    // Script allows to define custom Structs in it's body without deploying them to Network
    
    pub struct newStruct {
      pub let number: Int
      pub let address: Address
      
      // Adding underscores (_ number) before arguments allow you
      // to pass values without specifying the name of the arguments
      init(_ number: Int, _ address: Address){
        self.number = number
        self.address = address
      }
    }

    pub fun main(): newStruct {
      return newStruct(42, 0x1337)
    }
  `;

  // "query" will pass Cadence code to access node for execution and return us a result:
  // read more about "query" method on Flow Docs Site:
  // https://docs.onflow.org/fcl/reference/api/#query
  const custom = await query({ cadence });

  const { number, address } = custom;

  console.log(`Number field is ${number}`)
  console.log(`Address field is ${address}`)
};

(async () => {
  console.clear();
  await fetchCustom();
})();

```
