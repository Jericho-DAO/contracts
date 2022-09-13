// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "../libs/Base64.sol";
import "../libs/Counters.sol";

uint256 constant NUMBER_OF_NECKLACES = 50000;

contract CustomAttributes is ERC1155, ERC1155Burnable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public constant NECKLACE_OF_FRENSHIP = 0;
    uint256 public constant GATE_PASS = 1;
    uint256 public constant HAMMER = 2;
    uint256 public constant ANVIL = 3;

    struct Attr {
        string name;
        string description;
        string image;
    }

    mapping(uint256 => Attr) private attributes;
    mapping(address => uint256[]) public necklacesOwners;
    mapping(address => bool) public firstBelievers;
    mapping(address => bool) public jerichoMembers;

    error MissingGatePass();
    error MissingHammer();
    error MissingNecklace();

    error AlreadyHasGatePass();
    error AlreadyHasHammer();
    error IsNotJerichoMember();
    error AlreadyHasAnvil();

    error JerichoArtifactsNonTransferable();

    constructor() ERC1155("") {
        // arbitrary make the counter starting at 50000
        _tokenIds.setCounterValue(NUMBER_OF_NECKLACES);

        setAttributes(
            GATE_PASS,
            "Gate Pass",
            "The Gate Pass grants safe passage to Jericho.",
            "https://ipfs.io/ipfs/bafybeihlhjdvn6stihbuyeanckich66rq4hahvocilvhlhouhch43z75f4"
        );
        setAttributes(
            HAMMER,
            "Rain Hammer",
            "The Rain Hammer is an artifact built from Bifrost's fragments. It's granted by The Guardians of Jericho to high-potential builders. It's a prerequisite to getting Jericho citizenship.",
            "https://ipfs.io/ipfs/bafkreibeejuj2454fkgvqltmakptt73qv65x54wgjcsacpiftcocxe52te"
        );
        setAttributes(
            ANVIL,
            "Hudur's Anvil",
            "When Vulka died, her giant body was petrified on top of Mount Hudur, Jericho's biggest mountain. Her legs got destroyed in the process & scrambled into fragments we call Hudur's Stone, a unique stone that unveils true intentions. It is now used to produce Hudur's Anvils: Jericho's ID. As soon as you get one, you'll be recognized as a true Builder, and get access to all the Discord channels and our wiki.",
            "https://ipfs.io/ipfs/bafybeihj35lzf6k7wap7j2vh7uaudurtvqr42potwhsrwagrzbyipsyvl4"
        );
    }

    function setAttributes(
        uint256 tokenId,
        string memory name,
        string memory description,
        string memory image
    ) internal {
        attributes[tokenId] = Attr({
            name: name,
            description: description,
            image: image
        });
    }

    function setFirstBeliever(address believer) public onlyOwner {
        firstBelievers[believer] = true;
    }

    function removeFirstBeliever(address addr) public onlyOwner {
        delete firstBelievers[addr];
    }

    function isBeliever(address add) public view returns (bool) {
        return firstBelievers[add];
    }

    function setJerichoMember(address member) public onlyOwner {
        jerichoMembers[member] = true;
    }

    function removeJerichoMember(address addr) public onlyOwner {
        delete jerichoMembers[addr];
    }

    function isJerichoMember(address add) public view returns (bool) {
        return jerichoMembers[add];
    }

    function getAttributes(uint256 tokenId)
        public
        view
        returns (Attr memory att)
    {
        return attributes[tokenId];
    }

    function getSerializedAttributes(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        return
            Base64.encode(
                abi.encodePacked(
                    '{"name": "',
                    attributes[tokenId].name,
                    '",',
                    '"image": "',
                    attributes[tokenId].image,
                    '",',
                    '"description": "',
                    attributes[tokenId].description,
                    '"}'
                )
            );
    }

    function mint(
        uint256 artifact,
        address msgSender,
        address frenWallet,
        string memory usernameOwner,
        string memory usernameFren
    ) public {
        if (artifact == GATE_PASS) {
            if (balanceOf(msgSender, GATE_PASS) > 0)
                revert AlreadyHasGatePass();
            _mint(msgSender, GATE_PASS, 1, "0x000");
        } else if (artifact == HAMMER) {
            if (balanceOf(msgSender, GATE_PASS) == 0) revert MissingGatePass();
            if (balanceOf(msgSender, HAMMER) > 0) revert AlreadyHasHammer();
            _mint(msgSender, HAMMER, 1, "0x000");
        } else if (artifact == NECKLACE_OF_FRENSHIP) {
            if (balanceOf(msgSender, GATE_PASS) == 0) revert MissingGatePass();
            if (balanceOf(msgSender, HAMMER) == 0) revert MissingHammer();
            if (balanceOf(frenWallet, GATE_PASS) == 0) revert MissingGatePass();
            if (balanceOf(frenWallet, HAMMER) == 0) revert MissingHammer();

            uint256 newItemId = _tokenIds.current();
            
            setAttributes(
                newItemId,
                string(
                    abi.encodePacked(
                        "Necklace of Frenship: ",
                        usernameOwner,
                        " & ",
                        usernameFren
                    )
                ),
                string(
                    abi.encodePacked(
                        "The Necklace of frenship is a pretty common artifact in Jericho. Families and frens have been exchanging Necklaces of frenship for centuries as a prayer for eternal frenship. The two fren wallets are engraved in the Necklace of frenship. You can't fake connections in Jericho. A fren is a fren. This Necklace proves that ",
                        Strings.toHexString(uint256(uint160(msgSender)), 20),
                        " is fren with wallet ",
                        Strings.toHexString(uint256(uint160(frenWallet)), 20)
                    )
                ),
                "https://ipfs.io/ipfs/bafkreibyhgtflzzfykz7tfnvbxoueajc4yet3mge4kpd5pzcy2k7iixva4"
            );

            necklacesOwners[msgSender].push(newItemId);
            necklacesOwners[frenWallet].push(newItemId);

            _mint(msgSender, newItemId, 1, "0x000");
            _mint(frenWallet, newItemId, 1, "0x000");

            _tokenIds.increment();
        } else if (artifact == ANVIL) {
            if (balanceOf(msgSender, GATE_PASS) == 0) revert MissingGatePass();
            if (balanceOf(msgSender, HAMMER) == 0) revert MissingHammer();
            if (isJerichoMember(msgSender) == false)
                revert IsNotJerichoMember();
            if (
                necklacesOwners[msgSender].length == 0 &&
                isBeliever(msgSender) == false
            ) revert MissingNecklace();
            if (balanceOf(msgSender, ANVIL) > 0) revert AlreadyHasAnvil();

            _mint(msgSender, ANVIL, 1, "0x000");
        }
    }

    function forcedBurn(
        address addressToBurn,
        uint256 tokenId,
        uint256 value
    ) public onlyOwner {
        _burn(addressToBurn, tokenId, value);
    }

    function forcedBurnBatch(
        address addressToBurn,
        uint256[] memory tokenIds,
        uint256[] memory values
    ) public onlyOwner {
        _burnBatch(addressToBurn, tokenIds, values);
    }

    function safeTransferFrom(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) public pure override {
        revert JerichoArtifactsNonTransferable();
    }

    function safeBatchTransferFrom(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) public pure override {
        revert JerichoArtifactsNonTransferable();
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155) {}

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
