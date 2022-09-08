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
