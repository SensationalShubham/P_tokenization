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

    function test_InitiallyPause() external {
        assertEq(erc721.pause(), true);
    }

    function test_pauseFunctionality() public{
        // not able to access it
        // vm.prank(address(0));
        erc721.pauseResume();
        bool pauseAfter = erc721.pause();
        assertEq(pauseAfter, false);
    }


    function test_whoIstheOwner() public{
        vm.prank(address(0));
        erc721.mint();
        address owner = erc721.getOwner(0);
        console.log(owner);
        assertEq(owner, address(0));
    }

    function test_exceedSupply() public {
        for(uint i = 0; i < 10; i++){
            erc721.mint();
        }
        console.log(erc721.tokenId());
        vm.expectRevert(bytes("Apologies! We reached the cap!"));
        erc721.mint();
    }

    function test_checkBalance() public {
        for(uint i = 0; i < 10; i++){
            erc721.mint();
        }
        uint balance = erc721.getBalance(address(this));
        assertEq(balance, 10);
    }

    function test_getOwner() public {
        erc721.mint();
        vm.prank(address(0));
        erc721.mint();
        vm.prank(address(1));
        erc721.mint();

        address tokenOwner1 = erc721.getOwner(0);
        address tokenOwner2 = erc721.getOwner(1);
        address tokenOwner3 = erc721.getOwner(2);

        assertEq(tokenOwner1, address(this), "test1");
        assertEq(tokenOwner2, address(0), "test2");
        assertEq(tokenOwner3, address(1), "test3");
    }

    function test_revertIfAnotherApproves() public {
        vm.prank(address(0));
        erc721.mint();
        vm.prank(address(1));
        vm.expectRevert(bytes("Only token owner can approve this"));
        erc721.approve(address(1), 0);
    }

    function test_approve() public {
        vm.startPrank(address(0));
        erc721.mint();
        erc721.approve(address(1), 0);
        vm.stopPrank();
        address afterApproval = erc721.Approval(0);
        assertEq(afterApproval, address(1));
    }

    function test_eventApproves() public {
        vm.startPrank(address(0));
        erc721.mint();

        // vm.expectEmit(true, true, true, false);
        // not able to use this emit in test

        // emit Approve(address(0), address(1), 0);

        erc721.approve(address(1), 0);
        vm.stopPrank();
    }
}

// address deploy 
//0x5FbDB2315678afecb367f032d93F642f64180aa3