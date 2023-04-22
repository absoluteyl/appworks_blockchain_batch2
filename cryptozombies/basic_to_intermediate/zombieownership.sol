// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./zombieattack.sol";
import "./erc721.sol";

// @title A contract that manages transfering zombie ownership
// @author absoluteyl
// @dev Compliant with OpenZeppelin's implementation of the ERC721 spec draft
contract ZombieOwnership is ZombieAttack, IERC721 {

  mapping(uint => address) zombieApprovals;

  function balanceOf(address _owner) external view returns (uint256) {
    // 1. Return the number of zombies `_owner` has
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
    // 2. Return the owner of `_tokenId`
    return zombieToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
    ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
    zombieToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
    // msg.sender must be the owner of zombie or who has been approved.
    require(zombieToOwner[_tokenId] == msg.sender ||zombieApprovals[_tokenId] == msg.sender);
    _transfer(_from, _to, _tokenId);
  }

  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
    zombieApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }
}
