## Day 70/100 Days of Cadence

🔁 [Control Flow: Looping](https://developers.flow.com/cadence/language/control-flow#looping)

### `while-statment`
* Allows certain code to be executed *repeatedly* as long as the condition remains true.
* Must be boolean and braces are required

```cadence
var e = 0 

while e < 7 {
  e = e + 1
}
```

### `for-in statement`
* Allows certain code to be executed *repeatedly* for each element in an array
* Code that should be exexuted is enclosed in curly braces
* If no elements exists in the data structure, no code will be executed
* Code will execute as many times as there are elements in the array

```cadence
let myArray = ["France", "Germany", "Spain"]

for element in myArray {
  log(element)
}

```
* An additional variable preceeding the element can be included - **index** - must be seperated by a comma

```cadence
// Contains the current index of the array being iterated through during each repeated execution
let myArray = ["France", "Germany", "Spain"]

for index, element in myArray {
  log(index)
}
```
* **Dictionary Entries**
  * Use for-in loop to iterate over a dictionary's entries (keys and values)
```cadence
let myDictionary = {"hello": "Hello, World!", "bye": "Goodbye, World!"}

for key in myDictionary.keys {
  let value = myDictionary[key]!
  log(key)
  log(value)
}
```

### `continue` and `break`
* `continue` in while and for loops to stop the current loop and start a new one

```cadence
var i = 0
var x = 0
while i < 10 {
  i = i + 1
  if i < 3 {
    continue
  }
  x = x + 1
}

let array = [2, 2, 3]
var sum = 0
for element in array {
  if element == 2 {
    continue
  }
  sum = sum + element
}
```
* `break` is used to stop for or while loops

```cadence
var x = 0
while x < 10 {
  x = x + 1
  if x == 5 {
    break
  }
}

let array = [1, 2, 3]
var sum = 0
for element in array {
  if element == 2 {
    break
  }
  sum = sum + element
}

```
