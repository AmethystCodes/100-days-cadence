## Day 75/100 Days of Cadence

[Flow Docs: Composite Types](https://developers.flow.com/cadence/language/composite-types#composite-type-subtyping)

## 💥Composite Types (cont.)

### Subtyping 

* Two composite types are compatible if they refer to the same declaration by name
* If types declare the same fields and functions, they are only compatible if their names match

**Example**
```cadence

struct One {
  fun add() {}
}

struct Two {
  fun add()
}

var newVariable: One = One()

// Invalid: Types' names differ, so they are not compatible
newVariable = Two()

// Valid: Will reassign a new value of type `One`
newVariable = One()

```

### Behavior

**Structures**
* Copied when used as an initial value for constant or variable, assigned to a different variable, passed as an argument to a function, and returned from a function
* Accessing a field or calling a function does not copy it

```cadence
// From Flow docs:
// Declare a structure named `SomeStruct`, with a variable integer field.
//
pub struct SomeStruct {
    pub var value: Int

    init(value: Int) {
        self.value = value
    }

    fun increment() {
        self.value = self.value + 1
    }
}

// Declare a constant with value of structure type `SomeStruct`.
//
let a = SomeStruct(value: 0)

// *Copy* the structure value into a new constant.
//
let b = a

b.value = 1
// NOTE: `b.value` is 1, `a.value` is *`0`*

b.increment()
// `b.value` is 2, `a.value` is `0`

```

**Using Optional Chaining**
* Can be used to get the value of call the function without having to get the value of the optional first
* Used by adding a `?` before the `.` access operator for fields and functions of an optional composite type
* When getting a field value or calling a function with a return value, the access returns the value as an optional. If the object doesn't exist, the value will always be `nil`
* Invalid to access an undeclared field of an optional composite type

**Forced-Optional Chaining**
* Used by adding a `!` before the `.` access operator for fields or functions of an optional composite type

**Example of Optional Chaining (`?`):**
```cadence
// From Flow docs: 
// Declare a struct with a field and method.
pub struct Value {
    pub var number: Int

    init() {
        self.number = 2
    }

    pub fun set(new: Int) {
        self.number = new
    }

    pub fun setAndReturn(new: Int): Int {
        self.number = new
        return new
    }
}

// Create a new instance of the struct as an optional
let value: Value? = Value()
// Create another optional with the same type, but nil
let noValue: Value? = nil

// Access the `number` field using optional chaining
let twoOpt = value?.number
// Because `value` is an optional, `twoOpt` has type `Int?`
let two = twoOpt ?? 0
// `two` is `2`

// Try to access the `number` field of `noValue`, which has type `Value?`.
// This still returns an `Int?`
let nilValue = noValue?.number
// This time, since `noValue` is `nil`, `nilValue` will also be `nil`

// Try to call the `set` function of `value`.
// The function call is performed, as `value` is not nil
value?.set(new: 4)

// Try to call the `set` function of `noValue`.
// The function call is *not* performed, as `noValue` is nil
noValue?.set(new: 4)

// Call the `setAndReturn` function, which returns an `Int`.
// Because `value` is an optional, the return value is type `Int?`
let sixOpt = value?.setAndReturn(new: 6)
let six = sixOpt ?? 0
// `six` is `6`
```
**Example of Forced-Optional Chaining (`!`):**
```cadence
// From Flow docs: 
// Declare a struct with a field and method.
pub struct Value {
    pub var number: Int

    init() {
        self.number = 2
    }

    pub fun set(new: Int) {
        self.number = new
    }

    pub fun setAndReturn(new: Int): Int {
        self.number = new
        return new
    }
}

// Create a new instance of the struct as an optional
let value: Value? = Value()
// Create another optional with the same type, but nil
let noValue: Value? = nil

// Access the `number` field using force-optional chaining
let two = value!.number
// `two` is `2`

// Try to access the `number` field of `noValue`, which has type `Value?`
// Run-time error: This time, since `noValue` is `nil`,
// the program execution will revert
let number = noValue!.number

// Call the `set` function of the struct

// This succeeds and sets the value to 4
value!.set(new: 4)

// Run-time error: Since `noValue` is nil, the value is not set
// and the program execution reverts.
noValue!.set(new: 4)

// Call the `setAndReturn` function, which returns an `Int`
// Because we use force-unwrap before calling the function,
// the return value is type `Int`
let six = value!.setAndReturn(new: 6)
// `six` is `6`
```
