pragma solidity ^0.4.25;

import "erc721x/contracts/Core/ERC721X/ERC721XToken.sol";
import "./Ownable.sol";

contract CardGame is ERC721XToken, Ownable {

  mapping(uint => uint) internal tokenIdToIndividualSupply;
  mapping(uint => uint) internal nftTokenIdToMouldId;
  uint nftTokenIdIndex = 1000000;

  event TokenAwarded(uint indexed tokenId, address claimer, uint amount);

  function name() external view returns (string) {
    return "CardGame";
  }

  function symbol() external view returns (string) {
    return "CGM";
  }

  function individualSupply(uint _tokenId) public view returns (uint) {
    return tokenIdToIndividualSupply[_tokenId];
  }

  function batchMintTokens(uint[] _tokenIds, uint[] _tokenSupplies) external onlyOwner {
    for (uint i = 0; i < _tokenIds.length; i++) {
      mintToken(_tokenIds[i], _tokenSupplies[i]);
    } 
  }

  function mintToken(uint _tokenId, uint _supply) public onlyOwner {
    require(!exists(_tokenId), "Duplicate toekn id is detected");
    _mint(_tokenId, msg.sender, _supply);
    tokenIdToIndividualSupply[_tokenId] = _supply;
  }

  function awardToken(uint _tokenId, address _to, uint _amount) public onlyOwner {
    require(exists(_tokenId), "Token ID has not been minted");
    if (individualSupply(_tokenId) > 0) {
      require(_amount <= balanceOf(msg.sender, _tokenId), "Quantity greater than remaining cards");
      _updateTokenBalance(msg.sender, _tokenId, _amount, ObjectLib.Operations.SUB);
    }
    _updateTokenBalance(_to, _tokenId, _amount, ObjectLib.Operations.ADD);
    emit TokenAwarded(_tokenId, _to, _amount);
  }

  function convertToNFT(uint _tokenId, uint _amount) public {
    require(tokenType[_tokenId] == FT);
    require(_amount <= balanceOf(msg.sender, _tokenId), "You do not own enough tokens");
    _updateTokenBalance(msg.sender, _tokenId, _amount, ObjectLib.Operations.SUB);
    for (uint i = 0; i < _amount; i++) {
      _mint(nftTokenIdIndex, msg.sender);
      nftTokenIdToMouldId[nftTokenIdIndex] = _tokenId;
      nftTokenIdIndex++;
    }
  }

  function convertToFT(uint _nfttokenId) public {
    require(tokenType[_nfttokenId] == NFT);
    require(ownerOf(_nfttokenId) == msg.sender, "You do not own this token");
    _updateTokenBalance(msg.sender, _nfttokenId, 0, ObjectLib.Operations.REPLACE);
    _updateTokenBalance(msg.sender, nftTokenIdToMouldId[_nfttokenId], 1, ObjectLib.Operations.ADD);
  }

  function _mint(uint256 _tokenId, address _to, uint256 _supply) internal {
    // If the token doesn't exist, add it to the tokens array
    if (!exists(_tokenId)) {
      tokenType[_tokenId] = FT;
      allTokens.push(_tokenId);
    } else {
      // if the token exists, it must be a FT
      require(tokenType[_tokenId] == FT, "Not a FT");
    }

    _updateTokenBalance(_to, _tokenId, _supply, ObjectLib.Operations.ADD);
  }
}

