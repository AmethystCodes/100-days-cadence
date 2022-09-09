## Day 72/100 Days of Cadence

[🔍 Cadence Scope](https://developers.flow.com/cadence/language/scope)

[🦺 Type Safety](https://developers.flow.com/cadence/language/type-safety)

[🔗 Type Inference](https://developers.flow.com/cadence/language/type-inference)

## Scope
* Every function and block ({ ... }) introduces a new scope for declarations
  * Each function and block can refer to declarations in its scope or any of the outer scopes
  * Scope is lexical, not dynamic
* Examples:
```cadence
let x = 17

fun f(): Int {
    let y = 10
    return x + y
}

f()  // is `27`

// Invalid: the identifier `y` is not in scope
y
```
* Each scope can introduce new declarations
```cadence

let x = 10 

fun test(): Int {
  let x = 7
  return x
}

test() // is `7`
```
* Lexical, not dynamic
```cadence
let x = 25

fun f(): Int {
   return x
}

fun g(): Int {
   let x = 40
   return f()
}

g()  // is `25`, not `40`
```
## Type Safety

* Cadence is a *type-safe* language 
* Variables must be the same type when assigning new variables - a `bool` type can only be assigned a value type of `bool`
```cadence
// Declare a variable that has type `Bool`.
var a = true

// Invalid: cannot assign a value that has type `Int` to a variable which has type `Bool`.
//
a = 0
```
* When passing arguments to a function, the types of the values must match the function parameters' types
```cadence
fun nand(_ a: Bool, _ b: Bool): Bool {
    return !(a && b)
}

nand(false, false)  // is `true`

// Invalid: The arguments of the function calls are integers and have type `Int`,
// but the function expects parameters booleans (type `Bool`).
//
nand(0, 0)
```
* Types are **not** automatically converted
```cadence
fun add(_ a: Int8, _ b: Int8): Int8 {
    return a + b
}

// The arguments are not declared with a specific type, but they are inferred
// to be `Int8` since the parameter types of the function `add` are `Int8`.
add(1, 2)  // is `3`

// Declare two constants which have type `Int32`.
//
let a: Int32 = 3_000_000_000
let b: Int32 = 3_000_000_000

// Invalid: cannot pass arguments which have type `Int32` to parameters which have type `Int8`.
//
add(a, b)
```
## Type Inference
