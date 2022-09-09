// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "./utils/BaseRelayRecipient.sol";
import "./utils/CustomAttributes.sol";

contract JerichoArtifacts is BaseRelayRecipient, CustomAttributes {
    string public name;
    string public symbol;

    constructor(
        string memory _name,
        string memory _symbol,
        address _trustedForwarder
    ) {
        name = _name;
        symbol = _symbol;
        trustedForwarder = _trustedForwarder;
    }

    function uri(uint256 tokenId)
        public
        view
        override(ERC1155)
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    getSerializedAttributes(tokenId)
                )
            );
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function contractURI() public pure returns (string memory) {
        return
            "https://ipfs.io/ipfs/bafkreia66tetuisvtwfj3y74xv5675gmoetbha3suqio6knqjexpqnilvq";
    }

    function mintArtifact(
        uint256 artifact,
        address to,
        address frenWallet
    ) public {
        mint(artifact, to, frenWallet);
    }

    function setCustomAttributes(
        uint256 tokenId,
        string memory tokenName,
        string memory description,
        string memory image
    ) public onlyOwner {
        setAttributes(tokenId, tokenName, description, image);
    }

    function setTrustedForwarder(address _trustedForwarder) external onlyOwner {
        trustedForwarder = _trustedForwarder;
    }

    function _msgSender()
        internal
        view
        override(BaseRelayRecipient, Context)
        returns (address sender)
    {
        return BaseRelayRecipient._msgSender();
    }
}
