// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";

import "./utils/BaseRelayRecipient.sol";
import "./utils/CustomAttributes.sol";

contract JerichoArtifacts is BaseRelayRecipient, CustomAttributes {
    string public name;
    string public symbol;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant URI_SETTER_ROLE = keccak256("URI_SETTER_ROLE");

    constructor(
        string memory _name,
        string memory _symbol,
        address _trustedForwarder
    ) {
        name = _name;
        symbol = _symbol;
        trustedForwarder = _trustedForwarder;

        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(URI_SETTER_ROLE, _msgSender());
        _setupRole(MINTER_ROLE, _msgSender());
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

    function setURI(string memory newuri) public onlyRole(URI_SETTER_ROLE) {
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
    ) public onlyRole(MINTER_ROLE) {
        mint(artifact, to, frenWallet);
    }

    function setCustomAttributes(
        uint256 tokenId,
        string memory tokenName,
        string memory description,
        string memory image
    ) public onlyRole(MINTER_ROLE) {
        setAttributes(tokenId, tokenName, description, image);
    }

    function setTrustedForwarder(address _trustedForwarder)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
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
