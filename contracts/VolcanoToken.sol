// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract VolcanoToken is Ownable, ERC721("Volcano Coin", "VT") {
    struct Metadata {
        uint id;
        uint timestamp;
        string URI;
    }

    uint tokenId;

    mapping(address => Metadata[]) public records;

    function getRecords(address _add) public view returns(Metadata[] memory) {
        return records[_add];
    }

    function mint() public {
        _safeMint(msg.sender, tokenId);
        Metadata memory meta = Metadata(tokenId, block.timestamp, "Volcano Token NFT");
        records[msg.sender].push(meta);
        tokenId += 1;
    }

    function burn(uint _tokenId) public {
        require(ownerOf(_tokenId) == msg.sender, "You do not have permission to burn this token");
        _burn(_tokenId);
        _removeFromRecords(_tokenId);
    }

    function _removeFromRecords(uint _tokenId) internal {
        for (uint i = 0; i < records[msg.sender].length; i++) {
            if (records[msg.sender][i].id == _tokenId) {
                delete records[msg.sender][i];
            }
        }
    }
}
