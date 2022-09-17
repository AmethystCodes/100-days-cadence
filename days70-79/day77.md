## Day 77/100 Days of Cadence

* Contract with Resource Interface
```cadence
pub contract StreakTracker {

    pub resource interface IStreak {
        pub let id: UInt64
        pub let name: String
        pub let daysCompleted: UInt64
    }

    pub resource Streak: IStreak {
        pub let id: UInt64
        pub let name: String
        pub let daysCompleted: UInt64
        pub var quote: String

        pub fun changeQuote(newQuote: String) {
            self.quote = newQuote
        }

        init(name: String, daysCompleted: UInt64, quote: String) {
            self.id = self.uuid
            self.name = name
            self.daysCompleted = daysCompleted
            self.quote = quote
        } 
    }

    pub fun createStreak(name: String, daysCompleted: UInt64, quote: String): @Streak {
        return <- create Streak(name: name, daysCompleted: daysCompleted, quote: quote)
    }
}
```
