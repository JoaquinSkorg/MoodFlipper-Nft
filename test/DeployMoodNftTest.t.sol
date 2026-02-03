// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {DeployMoodNft} from "../script/DeployMoodNft.s.sol";
import {Test} from "forge-std/Test.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNftTest is Test {
    DeployMoodNft public deployer;

    function setUp() public {
        deployer = new DeployMoodNft();
    }

    function testConvertSvgToUri() public view {
        // SVG with NO trailing newline
        string memory svg = '<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg">'
            '<circle cx="50" cy="50" r="40" stroke="green" stroke-width="4" fill="yellow" />' "</svg>";

        string memory actualUri = deployer.svgToImageURI(svg);

        // Build expected URI exactly how the contract should
        string memory expectedUri = string(abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(bytes(svg))));

        assertEq(actualUri, expectedUri);
    }
}
