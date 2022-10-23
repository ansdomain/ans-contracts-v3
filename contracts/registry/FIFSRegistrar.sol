pragma solidity >=0.8.4;

import "./ANS.sol";

/**
 * A registrar that allocates subdomains to the first person to claim them.
 */
contract FIFSRegistrar {
    ANS ans;
    bytes32 rootNode;

    modifier only_owner(bytes32 label) {
        address currentOwner = ans.owner(
            keccak256(abi.encodePacked(rootNode, label))
        );
        require(currentOwner == address(0x0) || currentOwner == msg.sender);
        _;
    }

    /**
     * Constructor.
     * @param ansAddr The address of the ANS registry.
     * @param node The node that this registrar administers.
     */
    constructor(ANS ansAddr, bytes32 node) public {
        ans = ansAddr;
        rootNode = node;
    }

    /**
     * Register a name, or change the owner of an existing registration.
     * @param label The hash of the label to register.
     * @param owner The address of the new owner.
     */
    function register(bytes32 label, address owner) public only_owner(label) {
        ans.setSubnodeOwner(rootNode, label, owner);
    }
}
