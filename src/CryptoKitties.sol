// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CryptoKitties is ERC721 {
  // 记录下一个铸造的 NFT 的 tokenId
  uint256 public _nextTokenId = 1;
  // NFT 的结构体
  struct Kitty {
    uint256 momId;
    uint256 dadId;
    uint256 genes;
    uint256 generation;
    uint256 birthTime;
  }
  
  mapping(uint256 => Kitty) public kitties;
  // 初始化 NFT 名称和符号
  constructor() ERC721("CryptoKittiesToken", "CKT") {}

  // 铸造初代 NFT
  function createKittyGen0() public return (uint256) {
    uint256 genes = uint256(keccak256(abi.encodePacked(block.timestamp, _nextTokenId)));
    return _createKitty(0, 0, genes, 0, msg.sender);
  }

  // 铸造 NFT
  function _createKitty(
    uint256 momId,
    uint256 dadId,
    uint256 genes,
    uint256 generation,
    uint256 owner
  ) private returns (uint256) {
    kitties[_nextTokenId] = Kitty(momId, dadId, genes, generation, block.timestamp);
    _mint(owner, _nextTokenId)
    return _nextTokenId++;
  }

  // 铸造子代 NFT
  function breed(uint256 momId, uint256 dadId) public returns (uint256) {
    require(ownerOf(momId) == msg.sender, "Not the owner of the mom kitty");
    require(ownerOf(dadId) == msg.sender, "Not the owner of the dad kitty");

    Kitty memory mom = kitties[momId];
    Kitty memory dad = kitties[dadId];

    uint256 newGenes = (mom.genes + dad.genes) / 2;
    uint256 newGeneration = (mom.generation > dad.generation ? mom.generation : dad.generation) + 1;

    return _createKitty(momId, dadId, newGenes, newGeneration, msg.sender);
  }
  

}