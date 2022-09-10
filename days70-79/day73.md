## Day 73/100 Days of Cadence

[Restricted Types](https://developers.flow.com/cadence/language/restricted-types)

[Built-in Functions](https://developers.flow.com/cadence/language/built-in-functions)

[Block Information](https://developers.flow.com/cadence/language/environment-information#block-information)

## ⛓️ Restricted Types

* Structure and resource types can be restricted
* Restrictions are interfaces that allow access to a subset of the members and functions of the type
* `AnyStruct` and `AnyResource` can also be restricted
  * Can be omitted and only use the interface `{InterfaceName}` instead of `AnyResource{InterfaceName}`

```cadence
pub resource ResourceName: InterfaceName {}
```
```cadence
// Declare a resource interface named `HasCount`,
// which has a read-only `count` field
//
resource interface HasCount {
    pub let count: Int
}

// Declare a resource named `Counter`, which has a writeable `count` field,
// and conforms to the resource interface `HasCount`
//
pub resource Counter: HasCount {
    pub var count: Int

    init(count: Int) {
        self.count = count
    }

    pub fun increment() {
        self.count = self.count + 1
    }
}
```

## ⚙️ Built-in Functions

`panic` - Terminates the program unconditionally

```cadence 
let account = optionalAccount ?? panic("missing account")
```

`assert` - Terminates the program if the given condition is false

```cadence
assert(_ condition: Bool, message: String)

// Message argument is optional 
```

`unsafeRandom` - Returns a pseudo-random number; use of this function is unsafe if not used correctly

```cadence
unsafeRandom(): UInt64
```
* Use [best practices](https://github.com/ConsenSys/smart-contract-best-practices/blob/051ec2e42a66f4641d5216063430f177f018826e/docs/recommendations#remember-that-on-chain-data-is-public) with this function

`RLP` - Recursive Length Prefix (RLP) allows the encoding of arbitrarily nested arrays of binary data

* `decodeString` - Decodes an RLP-encoded byte array 
```cadence
decodeString(_ input: [UInt8]): [UInt8]
```

* `decodeList` - Decodes an RLP-encoded list into an array of RLP-encoded items
```cadence
decodeList(_ input: [UInt8]): [[UInt8]]
```

## 🖥️ Block Information

`getCurrentBlock(): Block` - returns the current block

`getBlock(at height: UInt64): Block?` - returns the block at the given height

### `Block`
```cadence

pub struct Block {
    /// The ID of the block.
    ///
    /// It is essentially the hash of the block.
    ///
    pub let id: [UInt8; 32]

    /// The height of the block.
    ///
    /// If the blockchain is viewed as a tree with the genesis block at the root,
    // the height of a node is the number of edges between the node and the genesis block
    ///
    pub let height: UInt64

    /// The view of the block.
    ///
    /// It is a detail of the consensus algorithm. It is a monotonically increasing integer
    /// and counts rounds in the consensus algorithm. Since not all rounds result in a finalized block,
    /// the view number is strictly greater than or equal to the block height
    ///
    pub let view: UInt64

    /// The timestamp of the block.
    ///
    /// Unix timestamp of when the proposer claims it constructed the block.
    ///
    /// NOTE: It is included by the proposer, there are no guarantees on how much the time stamp can deviate from the true time the block was published.
    /// Consider observing blocks’ status changes off-chain yourself to get a more reliable value.
    ///
    pub let timestamp: UFix64
}
```
