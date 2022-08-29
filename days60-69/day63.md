## Day 63/100 Days of Cadence

### 🛠️ Build on Flow | Learn FCL Series
[Add and Revoke Public Keys](https://dev.to/onflow/build-on-flow-learn-fcl-15-how-to-add-and-revoke-public-keys-4k8c)

[Flow Docs: Add Key](https://docs.onflow.org/cadence/language/accounts/#add-account-keys)

[Flow Docs: Revoke Key](https://docs.onflow.org/cadence/language/accounts/#revoke-account-keys)

* index.js
```javascript
import { config, query, mutate, tx } from "@onflow/fcl";
import { signer } from "./signer";

config({
  "accessNode.api": "https://rest-testnet.onflow.org"
});

const addPublicKey = async (publicKey) => {
  if (!publicKey) {
    console.warning("Public Key should not be empty");
    return false;
  }

  console.log("%cSigning Transaction", `color: teal`);

  const cadence = `
  transaction(publicKey: String, weight: UFix64) {
    prepare(signer: AuthAccount) {
      let bytes = publicKey.decodeHex()

      let key = PublicKey(
        publicKey: bytes,
        signatureAlgorithm: SignatureAlgorithm.ECDSA_P256
      )

      var clampledWeight = weight
      // weight should be in range 0 to 1000
      if(clampledWeight > 1000.0){
        clampledWeight = 1000.0
      }
  
      signer.keys.add(
        publicKey: key,
        hashAlgorithm: HashAlgorithm.SHA3_256,
        weight: clampledWeight
      )
    }
  }
  `;

  // List of arguments
  const weight = (0).toFixed(1); // zero weight keys are perfectly fine for Proposer role
  const args = (arg, t) => [arg(publicKey, t.String), arg(weight, t.UFix64)];

  // Roles
  const proposer = signer;
  const payer = signer;
  const authorizations = [signer];

  // Execution limit
  const limit = 1000;

  // "mutate" method will return us transaction id
  const txId = await mutate({
    cadence,
    args,
    proposer,
    payer,
    authorizations,
    limit
  });

  console.log(`Submitted transaction ${txId} to the network`);
  console.log("%cWaiting for transaction to be sealed...", `color: teal`);

  const label = "Transaction Sealing Time";
  // We will use transaction id in order to "subscribe" to it's state change and get the details
  // of the transaction
  console.time(label);
  const txDetails = await tx(txId).onceSealed();
  console.timeEnd(label);
  return txDetails;
};

const revokePublicKey = async (keyIndex) => {
  if (!keyIndex) {
    console.warning("Public Key should not be empty");
    return false;
  }
  console.log("%cSigning Transaction", `color: teal`);
  const cadence = `
    transaction(keyIndex: Int){
      prepare(signer: AuthAccount){
        signer.keys.revoke(keyIndex:keyIndex)
      }
    }
  `;
  const args = (arg, t) => [arg(keyIndex.toString(), t.Int)];

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
  // We will use transaction id in order to "subscribe" to it's state change and get the details
  // of the transaction
  console.time(label);
  const txDetails = await tx(txId).onceSealed();
  console.timeEnd(label);
  return txDetails;
};

(async () => {
  console.clear();

  // PublicKey doesn't need to be unique, so we are gonna use exactly the same one
  // that already exist on account. This way we can control it with the same private key.
  const key =
    "790a6849decbc179e9904f7f601fbd629f1687f371484998ceb8c587303e05ae4f859c7aa91f8493642de1039039d2da9650b4b7d9d44d2486e7a2adabf602bc";

  // Uncomment this block to add public key
  const txDetails = await addPublicKey(key);
  console.log({ txDetails });

  // Uncomment this block to revoke key
  /*
  const txDetails = await revokePublicKey(2);
  console.log({ txDetails });
  */
})();


```

* signer.js
```javascript
import { sansPrefix, withPrefix } from "@onflow/fcl";
import { SHA3 } from "sha3";
import elliptic from "elliptic";

const curve = new elliptic.ec("p256");

const hashMessageHex = (msgHex) => {
  const sha = new SHA3(256);
  sha.update(Buffer.from(msgHex, "hex"));
  return sha.digest();
};

const signWithKey = (privateKey, msgHex) => {
  const key = curve.keyFromPrivate(Buffer.from(privateKey, "hex"));
  const sig = key.sign(hashMessageHex(msgHex));
  const n = 32;
  const r = sig.r.toArrayLike(Buffer, "be", n);
  const s = sig.s.toArrayLike(Buffer, "be", n);
  return Buffer.concat([r, s]).toString("hex");
};

export const signer = async (account) => {
  // We are hard coding these values here, but you can pass those values from outside as well.

  const keyId = 0;
  const accountAddress = "0x5593df7d286bcdb8";
  const pkey =
    "248f1ea7b4a058c39dcc97d91e6a5d0aa7afbc931428561b6efbc7bd0f5e0875";

  // authorization function need to return an account
  return {
    ...account, // bunch of defaults in here, we want to overload some of them though
    tempId: `${accountAddress}-${keyId}`, // tempIds are more of an advanced topic, for 99% of the times where you know the address and keyId you will want it to be a unique string per that address and keyId
    addr: sansPrefix(accountAddress), // the address of the signatory, currently it needs to be without a prefix right now
    keyId: Number(keyId), // this is the keyId for the accounts registered key that will be used to sign, make extra sure this is a number and not a string

    // Where the magic happens! ✨
    signingFunction: async (signable) => {
      // Singing functions are passed a signable and need to return a composite signature
      // signable.message is a hex string of what needs to be signed.
      const signature = await signWithKey(pkey, signable.message);
      return {
        addr: withPrefix(accountAddress), // needs to be the same as the account.addr but this time with a prefix, eventually they will both be with a prefix
        keyId: Number(keyId), // needs to be the same as account.keyId, once again make sure its a number and not a string
        signature // this needs to be a hex string of the signature, where signable.message is the hex value that needs to be signed
      };
    }
  };
};

```
