// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts/utils/Strings.sol";

import "./utils/Counters.sol";
import "./utils/BaseRelayRecipient.sol";
import "./utils/AccessProtected.sol";
import "./utils/CustomAttributes.sol";

contract JerichoArtifacts is AccessProtected, BaseRelayRecipient, CustomAttributes {
    // Contract name
    string public name;
    // Contract symbol
    string public symbol;

    constructor(string memory _name, string memory _symbol, address _trustedForwarder) {
        name = _name;
        symbol = _symbol;
        trustedForwarder = _trustedForwarder;
    }

    function uri(uint256 tokenId) override public view returns (string memory) {
        return string(abi.encodePacked('data:application/json;base64,', getSerializedAttributes(tokenId, _msgSender())));
    }    

    // Update for collection-specific metadata.
    function contractURI() public pure returns (string memory) {
        return "https://ipfs.io/ipfs/bafkreia66tetuisvtwfj3y74xv5675gmoetbha3suqio6knqjexpqnilvq";
    }

    function mintArtifact(uint256 artifact, address frenWallet) public{
      mint(artifact, frenWallet);
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    )
        internal override 
    {}

    /**
     * Set Trusted Forwarder
     *
     * @param _trustedForwarder - Trusted Forwarder address
     */
    function setTrustedForwarder(address _trustedForwarder) external onlyAdmin {
        trustedForwarder = _trustedForwarder;
    }

    function _msgSender()
        internal
        override(BaseRelayRecipient, Context)
        view
        returns (address sender)
    {
        return BaseRelayRecipient._msgSender();
    }
}