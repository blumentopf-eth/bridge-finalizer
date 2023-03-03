//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IMainlandPortal {
  function receiveMessage(bytes calldata inputData) external;
}

contract Bridgefin {
  
    address public owner;
    address public mainlandPortal;
    bytes[] chunks;

    constructor() {
        owner = msg.sender;
        mainlandPortal = 0xB119Ae8Ba985B2A02b395FC39B28DeFF828eCFc5;
    }

    function addChunk(bytes calldata inputData) public {
        require(msg.sender == owner, "Not owner");
        chunks.push(inputData);
    }

    function clearChunks() public{
      require(msg.sender == owner, "Not owner");
      delete chunks;
    }

    function joinChunks() public view returns (bytes memory) {
      require(chunks.length>0, "no chunks");

      bytes memory fullData = chunks[0];

      for (uint i = 1; i < chunks.length; i++) {
        fullData = bytes.concat(fullData, chunks[i]);
      }

      return fullData;
    }

    function changePortalAddress(address newAddress) public{
      require(msg.sender == owner, "Not owner");
      mainlandPortal = newAddress;
    }

    function callPortal() public{
      IMainlandPortal(mainlandPortal).receiveMessage(joinChunks());
    }
}