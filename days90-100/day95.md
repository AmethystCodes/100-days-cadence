## Day 95/100 Days of Cadence

[NFT StorefrontV2](https://github.com/onflow/nft-storefront/blob/main/contracts/NFTStorefrontV2.cdc) - Latest Version deployed to testnet

## 1️⃣ Primer
* **V2** is the recommended version (at time of writing)
* Create a non-custodial NFT marketplace which standardizes buying and selling of NFTs in a decentralized way across Flow
* Marketplaces and dApp devs can use listings offered across the chain on their marketplace UIs
* Sellers can list and manage NFTs for sale across multiple marketplaces

## 🛠️ Usage
* Each account that wants to offer NFTs for sale installs a `Storefront`
  * Individual sales are listed as `Listing` resources
    * `Listing`s can list one or more cut percentages; each cut is delivered to a predefined address
    * NFTs can be listed in one or more `Listing` resources and the validity of the listing can be checked
    * Purchasers, marketplace and aggregators can watch for `Listing` events 

## 🔍 Overview
* Makes it simple for sellers to list NFTs in dApp specific marketplaces
* Devs leverage the APIs to manage listings being offered for sale/trades
* Listings can be made simultaneously on third-party marketplaces
* Automation of listings into well-known third-party marketplace UIs
* Flow's account based model ensures NFTs list for sale remain in the Sellers account until traded, regardless the number of listings posted on marketplaces

## ⚙️ Basics
* General purpose sales support contract for NFTs
* Accounts wanting to list an NFT for sale creates a `Storefront` resource 
  * Individual sales within the Storefront are `Listings`
* Usually only one `Storefront` per account - stored at `/storage/NFTStorefrontV2` and supports all tokens using the `NonFungibleToken` standard
* Each listing defines:
  * Price
  * Optional 0-n sale cuts to deduct
  * Can specify an optional list of marketplace receiver capabilites used to pay commission
  * Royalities
 * Same NFT can be referenced in one or more marketplace
 * Parties can globally track `Listing` events on-chain
  * Filter by type, ID, and other characteristics    

### 🔗 [APIs & Events](https://github.com/onflow/nft-storefront/blob/main/docs/documentation.md#apis--events-offered-by-nftstorefrontv2)
