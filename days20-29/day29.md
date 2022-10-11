## Day 29/100 Days of Cadence

### [Emerald City Dapp Course](https://github.com/emerald-dao/beginner-dapp-course)

**Chapter 2.0 Day 2 Quests**

**1. Change the color of "Emerald DApp" to whatever color you want**

**2. Change the font size of the title**

**3. Change the "Emerald DApp" link to a different link (this means messing with the <a> tag)**

**4. There are two parts.**
    
  * 4a. Inside of your `<main>` tag, add a `<p>` tag and put whatever text you want in it.

  * 4b. Go to the `.main` class and add this line: `flex-direction: column`. Watch what it does!
  
  ```css
  .main {
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
}

.title {
  font-size: 60px;
  color: #28282B;
}

.title a {
  background-image: linear-gradient(90deg, #00C9FF 0%, #92FE9D 100%);
  background-clip: text;
  color: transparent;
  text-decoration: none;
}

.p {
  font-size: 25px;
  color: #28282B;
}
  
```
```javascript
import Head from 'next/head'
import styles from '../styles/Home.module.css'

export default function Home() {
  return (
    <div className={styles.container}>
      <Head>
        <title>Emerald DApp</title>
        <meta name="description" content="Created by Emerald Academy" />
        <link rel="icon" href="https://i.imgur.com/hvNtbgD.png" />
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>
          Welcome to my <a href="https://twitter.com/AmethystCodes" target="_blank">Emerald Dapp!</a>
        </h1>
        <p className={styles.p}>✨ Where Dreams are Made ✨</p>
      </main>
    </div>
  )
}  
```
![Original Dapp Landing Page](https://github.com/AmethystCodes/ec-beginner-dapp-course/blob/main/images/dapp-landing-begin.png)
