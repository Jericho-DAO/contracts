// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./utils/BaseRelayRecipient.sol";
import "./utils/CustomAttributes.sol";

contract JerichoArtifacts is AccessControl, BaseRelayRecipient, CustomAttributes {
    // Contract name
    string public name;
    // Contract symbol
    string public symbol;

    constructor(string memory _name, string memory _symbol, address _trustedForwarder) {
        name = _name;
        symbol = _symbol;
        trustedForwarder = _trustedForwarder;

        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function uri(uint256 tokenId) override(ERC1155) public view returns (string memory) {
        return string(abi.encodePacked('data:application/json;base64,', getSerializedAttributes(tokenId)));
    }    

    // Update for collection-specific metadata.
    function contractURI() public pure returns (string memory) {
        return "https://ipfs.io/ipfs/bafkreia66tetuisvtwfj3y74xv5675gmoetbha3suqio6knqjexpqnilvq";
    }

    function mintArtifact(uint256 artifact, address to, address frenWallet) public onlyRole(DEFAULT_ADMIN_ROLE) {
      mint(artifact, to, frenWallet);
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
    function setTrustedForwarder(address _trustedForwarder) external onlyRole(DEFAULT_ADMIN_ROLE) {
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

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }


    function _burn(address addr, uint256 tokenId) internal onlyRole(DEFAULT_ADMIN_ROLE) {
        super._burn(addr, tokenId, 1);
    }
    
    function forcedBurn(address addr, uint tokenId) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _burn(addr, tokenId, 1);
    }
}