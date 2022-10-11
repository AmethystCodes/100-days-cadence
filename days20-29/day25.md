## Day 25/100 Days of Cadence

### buildspace Flow Track 

* Update Minting Transaction
```cadence
export const mintNFT = 
`
// REPLACE THIS WITH YOUR CONTRACT NAME + ADDRESS
import PawneeOnFlow from 0x01 

// Do not change these
import NonFungibleToken from 0x631e88ae7f1d7c20
import MetadataViews from 0x631e88ae7f1d7c20

transaction(
  recipient: Address,
  name: String,
  description: String,
  thumbnail: String,
) {
  prepare(signer: AuthAccount) {
    if signer.borrow<&PawneeOnFlow.Collection>(from: PawneeOnFlow.CollectionStoragePath) != nil {
      return
    }

    // Create a new empty collection
    let collection <- PawneeOnFlow.createEmptyCollection()

    // save it to the account
    signer.save(<-collection, to: PawneeOnFlow.CollectionStoragePath)

    // create a public capability for the collection
    signer.link<&{NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection}>(
      PawneeOnFlow.CollectionPublicPath,
      target: PawneeOnFlow.CollectionStoragePath
    )
  }


  execute {
    // Borrow the recipient's public NFT collection reference
    let receiver = getAccount(recipient)
      .getCapability(PawneeOnFlow.CollectionPublicPath)
      .borrow<&{NonFungibleToken.CollectionPublic}>()
      ?? panic("Could not get receiver reference to the NFT Collection")

    // Mint the NFT and deposit it to the recipient's collection
    PawneeOnFlow.mintNFT(
      recipient: receiver,
      name: name,
      description: description,
      thumbnail: thumbnail,
    )
    
    log("Minted an NFT and stored it into the collection")
  } 
}
`
```
* Displaying NFTs when logging in
```javascript
 const fetchNFTs = async () => {
    // Empty the images array
    setImages([]);
    let IDs = [];
    
    // Fetch the IDs with our script (no fees or signers necessary)
    try {
      IDs = await fcl.query({
        cadence: `${getIDs}`,
        args: (arg, t) => [
          arg(user.addr, types.Address), 
        ],
      })
    } catch(err) {
      console.log("No NFTs Owned")
    }
    
    let _imageSrc = []
    try{
      for(let i=0; i<IDs.length; i++) {
        const result = await fcl.query({
          cadence: `${getMetadata}`,
          args: (arg, t) => [
            arg(user.addr, types.Address), 
            arg(IDs[i].toString(), types.UInt64),
          ],
        })
        // If the source is an IPFS link, remove the "ipfs://" prefix
        if (result["thumbnail"].startsWith("ipfs://")) {
          _imageSrc.push(result["thumbnail"].substring(7))
          // Add a gateway prefix
          _imageSrc[i] = "https://nftstorage.link/ipfs/" + _imageSrc[i]
        }
        else {
          _imageSrc.push(result["thumbnail"])
        }
      }
    } catch(err) {
      console.log(err)
    }
    
    if(images.length < _imageSrc.length) {
      setImages((Array.from({length: _imageSrc.length}, (_, i) => i).map((number, index)=>
        <img style={{margin:"10px", height: "150px"}} src={_imageSrc[index]} key={number} alt={"NFT #"+number}
        />
      )))
    }
  }

```
```javascript
// Renders `fetchNFTs`
 useEffect(() => {
    if (user && user.addr) {
      fetchNFTs();
    }
  }
  , [user]);
```
```javascript
// Update Mint Component to display NFTs in wallet
  const RenderMint = () => {
    return (
      <div>
        <div className="button-container">
          <button className="cta-button button-glow" onClick={() => mint()}>
            Mint
          </button>
        </div>
        {images.length > 0 ? 
          <>
            <h2>Your NFTs</h2>
              <div className="image-container">
                {images}
              </ div>
          </> 
        : ""}
    </div>
    );
  }
```
```javascript

// Update logOut to reset NFTs displayed 
const logOut = () => {
    setImages([]);
    fcl.unauthenticate();
  };

```
