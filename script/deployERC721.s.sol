// //SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "../src/ERC721.sol";
import {Script} from "forge-std/Script.sol";

contract deployERC721 is Script {
    string tokenName = "ShubhCoin";
    string tokenSymbol = "SC";
    uint256 totalSupply = 10;
    uint256 decimal = 10**8;
    // ERC721 public erc721;

    function run() public returns(ERC721){
        vm.startBroadcast();
        ERC721 erc721 = new ERC721(tokenName, tokenSymbol, totalSupply, decimal);
        vm.stopBroadcast();
        return erc721;
    }
}
