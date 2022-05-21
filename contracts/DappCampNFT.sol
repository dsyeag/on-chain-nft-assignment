// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract DappCampNFT is ERC721Enumerable, Ownable {
    uint256 public MAX_MINTABLE_TOKENS = 5;

    constructor() ERC721("DappCamp NFT", "DCAMP") Ownable() {}

    string[] private collection = [
        string[] private roasts = [
            "light",
            "medium",
            "dark"
        ];
        int8[] private grinds = [1:50];
        string[] private origins = [
            "africa",
            "central america",
            "south america",
            "middle east",
            "southeast asia"
        ];
    ];

    function random(string memory input) internal pure returns (uint256) {
        return uint(keccak256(abi.encodePacked(input));
    }

    function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal pure returns (string memory) {
        item = uint(keccak256(abi.encodePacked(keyPrefix,tokenId.toString())));
        return sourceArray[item];
    }

    function getroast(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "ROAST", roasts);
    }

    function getgrind(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "GRIND", grinds);
    }

    function getorigin(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "ORIGIN", origins);
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        string[6] memory parts;

        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: black; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="white" /><text x="10" y="20" class="base">';
        parts[1] = getroast(tokenId);
        parts[2] = '</text><text x="10" y="40" class="base">';
        parts [3] = getgrind(tokenId);
        parts[4]= '</text><text x="10" y="40" class="base">';
        parts[5] = getorigin(tokenId);
        parts[6] = '</text></svg>';

        string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6]));
        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Dev #', toString(tokenId), '", "description": "Developers around the world are tired of working and contributing their time and effort to enrich the top 1%. Join the movement that is community owned, building the future from the bottom up.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;

    }

    function claim(uint256 tokenId) public {
        require(tokenId > 0 && tokenId < MAX_MINTABLE_TOKENS, "Token ID invalid");
        _safeMint(_msgSender(), tokenId);
    }
}
