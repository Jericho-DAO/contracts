// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "../libs/Base64.sol";
import "../libs/Counters.sol";

contract CustomAttributes is ERC1155, ERC1155Burnable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public constant GATE_PASS = 1;
    uint256 public constant HAMMER = 2;
    uint256 public constant ANVIL = 4;
    
    struct Attr {
        string name;
        string description;
        string image;
    }

    mapping(uint256 => Attr) private attributes;
    mapping(address => uint256[]) public necklacesOwners;

    constructor() ERC1155("") {
        // arbitrary make the counter starting at 50000
        _tokenIds.setCounterValue(50000);

        setAttributes(GATE_PASS, "Gate Pass", "The Gate Pass grants safe passage to Jericho.", "https://ipfs.io/ipfs/bafybeihlhjdvn6stihbuyeanckich66rq4hahvocilvhlhouhch43z75f4");
        setAttributes(HAMMER, "Rain Hammer", "The Rain Hammer is an artifact built from Bifrost's fragments. It's granted by The Guardians of Jericho to high-potential builders. It's a prerequisite to getting Jericho citizenship.", "https://ipfs.io/ipfs/bafkreibeejuj2454fkgvqltmakptt73qv65x54wgjcsacpiftcocxe52te");
        setAttributes(ANVIL, "Hudur's Anvil", "When Vulka died, her giant body was petrified on top of Mount Hudur, Jericho's biggest mountain. Her legs got destroyed in the process & scrambled into fragments we call Hudur's Stone, a unique stone that unveils true intentions. It is now used to produce Hudur's Anvils: Jericho's ID. As soon as you get one, you'll be recognized as a true Builder, and get access to all the Discord channels and our wiki.", "https://ipfs.io/ipfs/bafybeihj35lzf6k7wap7j2vh7uaudurtvqr42potwhsrwagrzbyipsyvl4");
    }

    function setAttributes(uint256 tokenId, string memory name, string memory description, string memory image) public {
        attributes[tokenId] = Attr({
            name: name,
            description: description,
            image: image
        });
    }

    function getAttributes(uint256 tokenId) public view returns (Attr memory att) {
        return attributes[tokenId];
    }

    function getSerializedAttributes(uint256 tokenId) public view returns (string memory) {
        if (tokenId != GATE_PASS && tokenId != ANVIL && tokenId != HAMMER) {
            return Base64.encode(
                    abi.encodePacked(
                    '{"name": "', attributes[tokenId].name, '",',
                    '"image": "', attributes[tokenId].image, '",',
                    '"description": "', attributes[tokenId].description,  '",',
                    '"attributes": [{"trait_type": "Necklace", "value": "', Strings.toString(tokenId - 50000), '"}]}'
                    )
            );
        }
        return Base64.encode(
                abi.encodePacked(
                '{"name": "', attributes[tokenId].name, '",',
                '"image": "', attributes[tokenId].image, '",',
                '"description": "', attributes[tokenId].description, '"}'
                )
        );
    }

    function mint(uint256 artifact, address msgSender, address frenWallet) public {
        if (artifact == 1) {
            require(balanceOf(msgSender,GATE_PASS) == 0,"you already have a Gate Pass");
            _mint(msgSender,GATE_PASS,1,"0x000");
        }
        else if (artifact == 2) {
            require(balanceOf(msgSender,GATE_PASS) > 0,"you need to have a Gate Pass");
            require(balanceOf(msgSender,HAMMER) == 0,"you already have a Hammer");
            _mint(msgSender,HAMMER,1,"0x000");
        }
        else if (artifact == 3) {
            require(balanceOf(msgSender,GATE_PASS) > 0,"you need to have a Gate Pass");
            require(balanceOf(msgSender,HAMMER) > 0,"you need to have a Hammer");
            require(balanceOf(frenWallet,GATE_PASS) > 0,"your fren has to have a Gate Pass");
            require(balanceOf(frenWallet,HAMMER) > 0,"your fren has to have a Hammer");
            uint256 newItemId = _tokenIds.current();

            setAttributes(newItemId, string(abi.encodePacked("Necklace of Frenship #" , Strings.toString(newItemId - 50000))), string(abi.encodePacked("The Necklace of frenship is a pretty common artifact in Jericho. Families and frens have been exchanging Necklaces of frenship for centuries as a prayer for eternal frenship. The two fren wallets are engraved in the Necklace of frenship. You can't fake connections in Jericho. A fren is a fren. This Necklace proves that ", Strings.toHexString(uint256(uint160(msgSender)), 20)," is fren with wallet ", Strings.toHexString(uint256(uint160(frenWallet)), 20))), "https://ipfs.io/ipfs/bafkreibyhgtflzzfykz7tfnvbxoueajc4yet3mge4kpd5pzcy2k7iixva4");

            necklacesOwners[msgSender].push(newItemId);
            necklacesOwners[frenWallet].push(newItemId);

            _mint(msgSender, newItemId,1,"0x000");
            _mint(frenWallet, newItemId,1,"0x000");

            _tokenIds.increment();
        }
        else if (artifact == 4) {
            require(balanceOf(msgSender,GATE_PASS) > 0,"you need to have a Gate Pass");
            require(balanceOf(msgSender,HAMMER) > 0,"you need to have a Hammer");
            require(necklacesOwners[msgSender].length > 0,"you need to have at least 1 Necklace of Frenship");
            require(balanceOf(msgSender,ANVIL) == 0,"you already have a Anvil");
            _mint(msgSender,ANVIL,1,"0x000");
        }
    }
}