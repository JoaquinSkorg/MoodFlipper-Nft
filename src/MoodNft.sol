// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    uint256 private s_tokenCounter;
    string private s_sadSvgImageURI;
    string private s_happySvgImageURI;

    error MoodNft__CantFlipMoodIfNotOwner();

    mapping(uint256 => Mood) private s_tokenIdToMood;

    enum Mood {
        SAD,
        HAPPY
    }

    constructor(string memory sadSvgImageURI, string memory happySvgImageURI) ERC721("MoodNft", "MOOD") {
        s_tokenCounter = 0;
        s_sadSvgImageURI = sadSvgImageURI;
        s_happySvgImageURI = happySvgImageURI;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function flipMood(uint256 tokenId) public {
        // only the owner of the token can flip its mood
        if (
            ownerOf(tokenId) != msg.sender && !isApprovedForAll(ownerOf(tokenId), msg.sender)
                && getApproved(tokenId) != msg.sender
        ) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }
        if (s_tokenIdToMood[tokenId] == Mood.SAD) {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        } else {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        }
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == Mood.SAD) {
            imageURI = s_sadSvgImageURI;
        } else {
            imageURI = s_happySvgImageURI;
        }

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "',
                            name(),
                            '", "description": "An NFT that reflects the owners mood.", "attributes": [{"trait_type": "moodiness", "value": 100}], "image": "',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }
}
