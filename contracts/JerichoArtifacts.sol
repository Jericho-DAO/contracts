// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/metatx/ERC2771Context.sol";

import "./utils/BaseRelayRecipient.sol";
import "./utils/AccessProtected.sol";

contract JerichoArtifacts is ERC1155, Pausable, ERC1155Burnable, AccessProtected, BaseRelayRecipient {
    uint256 public constant GATE_PASS = 1;
    uint256 public constant ANVIL = 2;
    uint256 public constant NECKLACE_OF_FRENSHIP = 3;
    uint256 public constant HAMMER = 4;

    // Contract name
    string public name;
    // Contract symbol
    string public symbol;

    constructor(string memory _name, string memory _symbol, address _trustedForwarder) ERC1155("https://ipfs.io/ipfs/bafybeiewcgnn4lmdesbwi6s6fndxoale35cy4m74v5gsttbnbfrp77tzoa/{id}.json") {
        name = _name;
        symbol = _symbol;
        trustedForwarder = _trustedForwarder;
    }

    function uri(uint256 _tokenid) override public pure returns (string memory) {
        return string(
            abi.encodePacked(
                "https://ipfs.io/ipfs/bafybeiewcgnn4lmdesbwi6s6fndxoale35cy4m74v5gsttbnbfrp77tzoa/",
                Strings.toString(_tokenid),".json"
            )
        );
    }

    // Update for collection-specific metadata.
    function contractURI() public pure returns (string memory) {
        return "https://ipfs.io/ipfs/bafkreia66tetuisvtwfj3y74xv5675gmoetbha3suqio6knqjexpqnilvq";
    }

    function mintGatePass() public{
        require(balanceOf(_msgSender(),GATE_PASS) == 0,"you already have a Gate Pass");
        _mint(_msgSender(),GATE_PASS,1,"0x000");
    }

    // If you do not have any Gate Pass the contract will let you buy the Anvil
    function mintHammer() public{
        require(balanceOf(_msgSender(),GATE_PASS) > 0,"you need to have a Gate Pass");
        require(balanceOf(_msgSender(),ANVIL) == 0,"you already have a Anvil");
        _mint(_msgSender(),HAMMER,1,"0x000");
    }

    // If you do not have any Gate Pass and an Anvil the contract will let you buy the Necklace of Frenship
    function mintNecklaceOfFrenship() public{
        require(balanceOf(_msgSender(),GATE_PASS) > 0,"you need to have a Gate Pass");
        require(balanceOf(_msgSender(),HAMMER) > 0,"you need to have a Anvil");
        _mint(_msgSender(),NECKLACE_OF_FRENSHIP,1,"0x000");
    }

    // If you do not have any Gate Pass, Anvil and Necklace of Frenship the contract will let you buy the Hammer
    function mintAnvil() public{
        require(balanceOf(_msgSender(),GATE_PASS) > 0,"you need to have a Gate Pass");
        require(balanceOf(_msgSender(),HAMMER) > 0,"you need to have a Anvil");
        require(balanceOf(_msgSender(),NECKLACE_OF_FRENSHIP) > 0,"you need to have a Necklace of Frenship");
        require(balanceOf(_msgSender(),ANVIL) == 0,"you already have a Hammer");
        _mint(_msgSender(),ANVIL,1,"0x000");
    }

    // Check if the sender has the Gate Pass
    function hasGatePass() public view returns (bool) {
        return balanceOf(_msgSender(),GATE_PASS) > 0;
    }

    // Check if the sender has the Anvil
    function hasAnvil() public view returns (bool) {
        return balanceOf(_msgSender(),ANVIL) > 0;
    }

    // Check if the sender has the Necklace of Frenship
    function hasNecklaceOfFrenship() public view returns (bool) {
        return balanceOf(_msgSender(),NECKLACE_OF_FRENSHIP) > 0;
    }

    // Check if the sender has the Hammer
    function hasHammer() public view returns (bool) {
        return balanceOf(_msgSender(),HAMMER) > 0;
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    )
        internal whenNotPaused override 
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