## Day 26/100 Days of Cadence

## 🔊[Events](https://docs.onflow.org/cadence/language/events/)
  * Special values that are emitted during the execution of a program. 
  ```cadence 
  // Emits event when the contract is created
   pub event ContractInitialized()
  
  ```
  * Can contain parameters
    * Valid types are boolean, string, integer 
    * Arrays and dictionaries of valid types
    * Structures where all fields have a valid event parameter type
    * Resource types are not allowed; when a resource is used as an argument, it's moved 
  * **Can** only be declared within the body of the contract; **Cannot be declared globally or inside resource and struct types**
  ### Emit an event - use the `emit` statement
  ```cadence
  emit ContractInitialized()
  ```
  * Emitting event restrictions:
    * Can only be invoked using an `emit` statement
    * Cannot be assigned to variables
    * Cannot be used as function parameters
    * Can only be emiited from the location they are declared      


## ⛓ [Core Events](https://docs.onflow.org/cadence/language/core-events/)
### Account created: when a new account gets created
```cadence
// Event name: flow.AccountCreated

pub event AccountCreated(address: Address)
```
### Account Key Added: when a key gets added to an account
```cadence
// Event name: flow.AccountKeyAdded
pub event AccountKeyAdded(
    address: Address,
    publicKey: PublicKey
)
```
### Account Key Removed: when a key gets removed from an account
```cadence
// Event name: flow.AccountKeyRemoved
pub event AccountKeyRemoved(
    address: Address,
    publicKey: PublicKey
)

```

### Account Contract Added: when a contract gets deployed to an account
```cadence
//Event name: flow.AccountContractAdded
pub event AccountContractAdded(
    address: Address,
    codeHash: [UInt8],
    contract: String
)
```

### Account Contract Updated: when a contract gets updated on an account
```cadence
// Event name: flow.AccountContractUpdated
pub event AccountContractUpdated(
    address: Address,
    codeHash: [UInt8],
    contract: String
)
```
### Account Contract Removed: when a contract gets removed from an account
```cadence
// Event name: flow.AccountContractRemoved
pub event AccountContractRemoved(
    address: Address,
    codeHash: [UInt8],
    contract: String
)
```

## 💥[Contract Updatability - Valid & Invalid Changes](https://docs.onflow.org/cadence/language/contract-updatability/)
