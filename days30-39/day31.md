## Day 31/100 Days of Cadence

### [Emerald City Dapp Course](https://github.com/emerald-dao/beginner-dapp-course)

**Chapter 2.0 Day 4**

**1. Change the printHello function to be called runTransaction.**

**2. Change the "Hello" text inside the button to "Run Transaction".**

**3. Inside the runTransaction function, add some code to console log your newGreeting variable to the developer console.**

**4. Go back to your webpage, type something into the input box, and press "Run Transaction". Open your developer console and you will see some thing being printed!**

To upload your quests, show us your ./pages/index.js file and take a screenshot of your newGreeting being printed to the developer console.**

`./pages/index.js`
```javascript
import Head from 'next/head'
import styles from '../styles/Home.module.css'
import Nav from '../components/Nav.jsx';
import { useState } from 'react';
 
export default function Home() {
 
  const [newGreeting, setNewGreeting] = useState('');
 
  function runTransaction() {
    console.log(newGreeting)
  }
 
  function printGoodbye() {
    console.log("Goodbye")
  }
  return (
    <div className={styles.container}>
      <Head>
        <title>Emerald DApp</title>
        <meta name="description" content="Created by Emerald Academy" />
        <link rel="icon" href="https://i.imgur.com/hvNtbgD.png" />
      </Head>
 
      <Nav />
 
      <main className={styles.main}>
        <h1 className={styles.title}>
          Welcome to my <a href="https://twitter.com/AmethystCodes" target="_blank">Emerald Dapp!</a>
        </h1>
        <p className={styles.p}>✨ Where Dreams are Made ✨</p>
        <div className={styles.flex}>
          <button onClick={runTransaction}>
            Run Transaction
          </button>
          <input onChange={(e) => setNewGreeting(e.target.value)}placeholder="Hello!!" />
        </div>
      </main>
    </div>
  )
}
```

![newGreeting](https://github.com/AmethystCodes/ec-beginner-dapp-course/blob/main/images/run-transaction-btn.png)
