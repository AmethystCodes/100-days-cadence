## Day 60/100 Days of Cadence

🛠️ Build on Flow | Learn FCL Series

[Modify the State of the Chain by Signing Transactions with Wallets](https://dev.to/onflow/build-on-flow-learn-fcl-13-how-to-modify-the-state-of-the-chain-by-signing-transactions-with-wallets-3ndl)

[Mutate Chain State by Signing Transactions with a Private Key](https://dev.to/onflow/build-on-flow-learn-fcl-14-how-to-mutate-chain-state-by-signing-transactions-with-a-private-key-5c4p)

* Modify the state of the chain by signing transactions with *wallets*
```javascript
// Propser: proposes to include changes done by transaction into the blockchain. Proposer role can be filled by any account on Flow blockchain.

// Payer: account who will pay the gas fees for transaction execution; can be any account on Flow

// Authorizers: list of accounts, who authorize any changes in their accounts, done by transaction they are signing

// Import query and config

import { query, config } from "@onflow/fcl";

// Config FCL

config({
  // Testnet Access Node
  "accessNode.api": "https://rest-testnet.onflow.org",
  // Specify the network
  "flow.network": "testnet",
  // Title of Dapp
  "app.detail.title": "Meow Dapp",
  // Icon Photo
  "app.detail.icon": "https://placekitten.com/g/200/200",
  // Wallet Discovery
  "discovery.wallet": "https://fcl-discovery.onflow.org/testnet/authn",
  "discovery.authn.endpoint": "https://fcl-discovery.onflow.org/api/testnet/authn",

  // Alias for the example contract
  "OxBasic": "0xafabe20e55e9ceb6"
});


const readCounter = async () => {
  const cadence = `
    import Basic from 0xBasic

    pub fun main(): UInt {
      return Basic.counter
    }
  `;
  const counter = await query({ cadence });
  console.log({ counter });
};

const shiftCounter = async (value) => {
  const cadence = `
    import Basic from 0xBasic

    transaction(shift: UInt8) {
      prepare(signer: AuthAccount) {
        Basic.incrementCounterBy(shift)
      }
    }
  `;

  // List of Arguments
  const args = (arg, t) => [
    // We need to pass UInt8 value, but it should be a string, remember? :)
    arg(value.toString(), t.UInt8)
  ];

  const txId = await MutationEvent({
    cadence,
    args,
    limit: 999
  });

  // We will use transaction id in order to "subscribe" to it's state // change and get the details of the transaction

  const txDetails = await txId(txId).onceSealed();
    return txDetails
};

(async () => {
  console.clear();
  //unauthenticate();

  await readCounter();

  const txDetails = await shiftCounter(10);
  console.log({ txDetails });

  await readCounter();
})();

```

* Mutate the state of the chain by signing transactions with a *private key*
```javascript
import { config, query, mutate, tx } from "@onflow/fcl";
import { signer } from "./signer"

config({
  "accessNode.api": "https://rest-testnet.onflow.org",
  "0xBasic": "0xafabe20e55e9ceb6"
});

const readCounter = async () => {
  const cadence = `
    import Basic from 0xBasic

    pub fun main():UInt{
      return Basic.counter
    }
  `;
  const counter = await query({ cadence });
  console.log({ counter });
};

const shiftCounter = async (value) => {
  console.log("%cSigning Transaction", `color: teal`);

  const cadence = `
    import Basic from 0xBasic

    transaction(shift: UInt8){
      prepare(signer: AuthAccount){
        Basic.incrementCounterBy(shift)
      }
    }
  `;

  // List of arguments
  const args = (arg, t) => [arg(value.toString(), t.UInt8)];
  const proposer = signer;
  const payer = signer;
  const authorizations = [signer];

  // "mutate" method will return us transaction id
  const txId = await mutate({
    cadence,
    args,
    proposer,
    payer,
    authorizations,
    limit: 999
  });

  console.log(`Submitted transaction ${txId} to the network`);
  console.log("%cWaiting for transaction to be sealed...", `color: teal`);

  const label = "Transaction Sealing Time";
  console.time(label);

  const txDetails = await tx(txId).onceSealed();

  console.timeEnd(label);
  return txDetails;
};

(async () => {
  console.clear();
  await readCounter();

  const txDetails = await shiftCounter(12);
  console.log({ txDetails });

  await readCounter();
})();
```
* Signer.js
```javascript
const hashMessageHex = (msgHex) => {
  const sha = new SHA3(256);
  sha.update(Buffer.from(msgHex, "hex"));
  return sha.digest();
};

const sighWithKey = (privateKey, msgHex) => {
  const key = curve.keyFromPrivate(Buffer.from(privateKey, "hex"));
  const sig = key.sign(hashMessageHex(msgHex));

  const n = 32;
  const r = sig.r.toArrayLike(Buffer, "be", n);
  const s = sig.s.toArrayLike(Buffer, "be", n);

  return Buffer.concat([r, s]).toString("hex");
};

export const signer = async (account) => {
  // Key Id needs to be a number not a String
  const keyId = Number(0);
  const accountAddress = "0x5593df7d286bcdb8";
  const pkey = "248f1ea7b4a058c39dcc97d91e6a5d0aa7afbc931428561b6efbc7bd0f5e0875";

  return {
    ...account, // bunch of defaults in here, we want to overload some of them though
    tempId: `${accountAddress}-${keyId}`, // tempIds are more of an advanced topic, for 99% of the times where you know the address and keyId you will want it to be a unique string per that address and keyId
    addr: sansPrefix(accountAddress), // the address of the signatory, currently it needs to be without a prefix right now
    keyId // this is the keyId for the accounts registered key that will be used to sign, make extra sure this is a number and not a string

    // Where the magic happens
    signingFunction: async (signable) => {
      // Signing functions are passed a signable and // need to return a composite signature
      // signable.message is a hex string of what ///// needs to be signed.
      const signature = await signWithKey(pkey, signable.message);

      return {
        // Needs to be the same as acct.addr but withPrefix
        addr: withPrefix(accountAddress),
        // Needs to be the same as account.keyID
        keyId,
        // Needs to be a hex string of the signaature
        signature
      };
    }
  };
};
```
