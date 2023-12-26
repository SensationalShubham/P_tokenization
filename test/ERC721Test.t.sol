// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {deployERC721} from "../script/deployERC721.s.sol";
import {ERC721} from "../src/ERC721.sol";

contract ERC721Test is Test{
    ERC721 public erc721;
    function setUp() public {
        deployERC721 deployer = new deployERC721();
        erc721 = deployer.run();
    }

    function test_Name() public {
        string memory name = erc721.getTokenName();
        assertEq(name, "ShubhCoin");
    }

    function test_symbol() public {
        string memory symbol = erc721.getTokenSymbol();
        assertEq(symbol, "SC");
    }

    function test_whoIstheOwner() public{
        erc721.mint();
        address owner = erc721.getOwner(0);
        console.log(owner);
        assertEq(owner, 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
    }

    // function test_tokenID() public {
    //     uint256 tokenID = erc721(tokenID);
    //     assertEq(tokenID, 1);
    // }
}

// address deploy 
//0x5FbDB2315678afecb367f032d93F642f64180aa3