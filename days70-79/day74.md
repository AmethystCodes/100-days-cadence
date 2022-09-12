## Day 74/100 Days of Cadence

[Flow Docs: Composite Types](https://developers.flow.com/cadence/language/composite-types#composite-type-subtyping)

## 💥Composite Types

* Allow composing simpler types into more complex types -> allow the composition of multiple values into one
* Can only be declared *within* a contract
* Two kinds of composite types: Structures & Resources
  * Structures: are copied; value types. Useful when copies with independent state are desired
    * Not ideal way to represent ownership because they are copied. More useful for representing information that can be grouped together, but doesn't have value or need to be owned or transferred   
  * Resources: are moved; linear types & must be used exactly once. Useful when it's desired to model ownership
    * Nesting resources is only allowed within other resource types, or in data structures - arrays and dictionaries   

### Declaration & Creation

* Composite types must be declared within contracts and not locally inside functions
* `struct` - used to declare a structure
* `resource` - used to declare a resource

```cadence
pub struct MyStruct {

}

pub resource MyResource {

}
```
* Structs are created by calling the type like a function
```cadence
let ourVariable = MyStruct()
```
* Resources are created by using the `create` keyword & calling the type like a function
```cadence
let newResource <- create MyResource()
```

### Fields

* Declared like variables and constants
* Initial value of fields are set in the initializer; **not** in the field declaration
* All fields **must** be initialized in the initializer
* Initializer's main purpose is to initalize fields, but it may also contain other code
  * Can delcare parameters and contain arbitrary code, but has no return type - it's always `Void` 
  * Declared using the `init` keyword
  * Always follows any fields
  * Kinds of fields: constant, variable
    * Constant: `let` after initialized with a value, they **cannot** have a new value assigned afterward
    * Variable: `var` can have new values assigned to them after being initialized
* Must be storable; Non-storable types:
  * Functions
  * Accounts
  * Transactions
  * References
* Can be read & set using access syntax - composite value followed by a dot and name of the field: `token.id`   

### Functions 

* Composite types may contain functions
* The special constant `self` refers to the composite value that the function is called on
* Functions do not support overloading - the ability to create multiple functions of the same name with different implementations

```cadence
// From Cadence docs:
// Declare a structure named "Rectangle", which represents a rectangle
// and has variable fields for the width and height.
//
pub struct Rectangle {
    pub var width: Int
    pub var height: Int

    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }

    // Declare a function named "scale", which scales
    // the rectangle by the given factor.
    //
    pub fun scale(factor: Int) {
        self.width = self.width * factor
        self.height = self.height * factor
    }
}

let rectangle = Rectangle(width: 2, height: 3)
rectangle.scale(factor: 4)
// `rectangle.width` is `8`
// `rectangle.height` is `12`
```
