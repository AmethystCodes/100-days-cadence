## Day 24/100 Days of Cadence

### [CryptoDappy](https://www.cryptodappy.com/)

* config.js
```javascript
import { config } from "@onflow/fcl";

config({
  "accessNode.api": process.env.REACT_APP_ACCESS_NODE,
  "discovery.wallet": process.env.REACT_APP_WALLET_DISCOVERY,
});
```
