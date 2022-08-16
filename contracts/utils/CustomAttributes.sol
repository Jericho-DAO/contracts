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
    uint256 public constant NECKLACE_OF_FRENSHIP = 3;
    uint256 public constant ANVIL = 4;
    
    struct Attr {
        string name;
        string description;
        string image;
    }

    mapping(uint256 => Attr) private attributes;
    mapping(address => mapping(uint256 => address)) public necklacesOfFrenshipData;

    constructor() ERC1155("") {
        // arbitrary make the counter starting at 50000
        _tokenIds.setCounterValue(50000);

        setAttributes(GATE_PASS, "Gate Pass", "The Gate Pass grants safe passage to Jericho.", "https://ipfs.io/ipfs/bafybeihlhjdvn6stihbuyeanckich66rq4hahvocilvhlhouhch43z75f4");
        setAttributes(HAMMER, "Rain Hammer", "The Rain Hammer is an artifact built from Bifrost's fragments. It's granted by The Guardians of Jericho to high-potential builders. It's a prerequisite to getting Jericho citizenship.", "https://ipfs.io/ipfs/bafkreibeejuj2454fkgvqltmakptt73qv65x54wgjcsacpiftcocxe52te");
        setAttributes(NECKLACE_OF_FRENSHIP, "Necklace of Frenship", "The Necklace of frenship is a pretty common artifact in Jericho. Families and frens have been exchanging Necklaces of frenship for centuries as a prayer for eternal frenship. The two fren wallets are engraved in the Necklace of frenship. You can't fake connections in Jericho. A fren is a fren.", "https://ipfs.io/ipfs/bafkreibyhgtflzzfykz7tfnvbxoueajc4yet3mge4kpd5pzcy2k7iixva4");
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

    function setNecklaceFrenship(address user, address fren, uint256 tokenId) public {
        necklacesOfFrenshipData[user][tokenId] = fren;
    }

    function getSerializedAttributes(uint256 tokenId, address msgSender) public view returns (string memory json) {
        string memory returnedJson;

        if (tokenId != GATE_PASS && tokenId != ANVIL && tokenId != HAMMER) {
            returnedJson = Base64.encode(
                bytes(string(
                    abi.encodePacked(
                    '{"name": "', attributes[tokenId].name, '",',
                        '"image": "', attributes[tokenId].image, '",',
                        '"description": "', attributes[tokenId].description, '",',
                        '"attributes": [{"trait_type": "Fren", "value": ', abi.encodePacked(necklacesOfFrenshipData[msgSender][tokenId]), '},'
                        ']}'
                    )
                ))
            );
        } else {
            returnedJson = Base64.encode(
                bytes(string(
                    abi.encodePacked(
                    '{"name": "', attributes[tokenId].name, '",',
                        '"image": "', attributes[tokenId].image, '",',
                        '"description": "', attributes[tokenId].description, '",',
                        ']}'
                    )
                ))
            );
        }

        return returnedJson;
    }

    function mint(uint256 artifact, address frenWallet) public{
        if (artifact == 1) {
            require(balanceOf(_msgSender(),GATE_PASS) == 0,"you already have a Gate Pass");
            _mint(_msgSender(),GATE_PASS,1,"0x000");
            _mint(frenWallet,GATE_PASS,1,"0x000");
        }
        else if (artifact == 2) {
            require(balanceOf(_msgSender(),GATE_PASS) > 0,"you need to have a Gate Pass");
            require(balanceOf(_msgSender(),HAMMER) == 0,"you already have a Hammer");
            _mint(_msgSender(),HAMMER,1,"0x000");
            _mint(frenWallet,HAMMER,1,"0x000");
        }
        else if (artifact == 3) {
            require(balanceOf(_msgSender(),GATE_PASS) > 0,"you need to have a Gate Pass");
            require(balanceOf(_msgSender(),HAMMER) > 0,"you need to have a Hammer");
            require(balanceOf(frenWallet,GATE_PASS) > 0,"your fren has to have a Gate Pass");
            require(balanceOf(frenWallet,HAMMER) > 0,"your fren has to have a Hammer");
            uint256 newItemId = _tokenIds.current();

            setAttributes(newItemId, string(abi.encodePacked("Necklace of Frenship #" , Strings.toString(newItemId))), "The Necklace of frenship is a pretty common artifact in Jericho. Families and frens have been exchanging Necklaces of frenship for centuries as a prayer for eternal frenship. The two fren wallets are engraved in the Necklace of frenship. You can't fake connections in Jericho. A fren is a fren.", "https://ipfs.io/ipfs/bafkreibyhgtflzzfykz7tfnvbxoueajc4yet3mge4kpd5pzcy2k7iixva4");

            setNecklaceFrenship(_msgSender(), frenWallet, newItemId);
            setNecklaceFrenship(frenWallet, _msgSender(), newItemId);

            _tokenIds.increment();

            _mint(_msgSender(),NECKLACE_OF_FRENSHIP,1,"0x000");
            _mint(frenWallet, NECKLACE_OF_FRENSHIP,1,"0x000");
        }
        else if (artifact == 4) {
            require(balanceOf(_msgSender(),GATE_PASS) > 0,"you need to have a Gate Pass");
            require(balanceOf(_msgSender(),HAMMER) > 0,"you need to have a Hammer");
            require(balanceOf(_msgSender(),NECKLACE_OF_FRENSHIP) > 0,"you need to have a Necklace of Frenship");
            require(balanceOf(_msgSender(),ANVIL) == 0,"you already have a Anvil");
            _mint(_msgSender(),ANVIL,1,"0x000");
        }
    }
}