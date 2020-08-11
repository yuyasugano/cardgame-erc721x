# Card Game
A test implementation with ERC721x multi-fungible token

# Requirements
The code is written in solidity version 0.4.25 and the test uses.

Here's information for workable environment.
 
```sh
$ truffle version
Truffle v4.1.15 (core: 4.1.15)
Solidity v0.4.25 (solc-js)

$ npm --version
6.4.1

$ node --version
v10.13.0

$ ganache-cli --version
Ganache CLI v6.2.5 (ganache-core: 2.3.3)
```
 
## Contracts
`CardGame` contract is a test solidity code for ERC721x muti-fungible token published by Loom with functions defined below:

```sh
function name() external view returns (string) {}  
function symbol() external view returns (string) {}  
function individualSupply(uint _tokenId) public view returns (uint) {}  
function mintToken(uint _tokenId, uint _supply) public onlyOwner {}  
function awardToken(uint _tokenId, address _to, uint _amount) public onlyOwner {}  
function convertToNFT(uint _tokenId, uint _amount) public {}  
function convertToFT(uint _tokenId) public {}  
function batchMintTokens(uint[] _tokenIds, uint[] _tokenSupplies) external onlyOwner {}  
```

## To Migrate:
1. Run: `truffle develop` under the application root
2. In the development console run: `compile`
3. Next run: `migrate` or (`migrate --reset`)

## To Test:
1. Migrate the contracts in the truffle development blockchain
2. `truffle test` or `test` in the truffle development console
 
## License
 
This code is licensed under the MIT License.
