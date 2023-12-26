// It's just a basic skeleton for ERC721 model

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ERC721 {
    string tokenName;
    string tokenSymbol;
    uint256 totalSupply;
    uint256 immutable i_decimal;
    uint256 public tokenId = 0;
    address owner;
    bool public pause = true;

    mapping(uint256 => address) public tokenOwners;
    mapping(uint256 => address) public Approval;

    event Approve(address indexed from, address indexed to, uint256 indexed tokenId);

    constructor(string memory _tokenName, string memory _tokenSybmol, uint256 _totalSupply, uint256 decimal) {
        owner = msg.sender;
        tokenName = _tokenName;
        tokenSymbol = _tokenSybmol;
        totalSupply = _totalSupply;
        i_decimal = decimal;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can access this");
        _;
    }

    function pauseResume() public onlyOwner {
        if (pause == true) {
            pause = false;
        } else {
            pause = true;
        }
    }

    function mint() public {
        require(pause == true, "Under Maintainence");
        require(tokenId < totalSupply, "Apologies! We reached the cap!");
        tokenOwners[tokenId] = msg.sender;
        tokenId++;
    }

        /**
         * 
         * @dev If the msg.sender is other than the one who owns the token, then he/she must have to be in the Approve list before transferring the token. 
         */
        
    function safeTransferFrom(address from, address to, uint256 _tokenId) public {
        require(pause == true, "Under Maintainence");
        if (msg.sender == from) {
            require(tokenOwners[_tokenId] == msg.sender, "You don't own this token");
            tokenOwners[_tokenId] = to;
        } else {
            // Show the Approval
            if (getApproved(_tokenId) == to) {
                tokenOwners[_tokenId] = to;
            }
        }
    }

    function approve(address to, uint256 _tokenId) public {
        require(tokenOwners[_tokenId] == msg.sender, "Only token owner can approve this");
        Approval[_tokenId] = to;
        emit Approve(msg.sender, to, _tokenId);
    }

    function getApproved(uint256 _tokenId) public view returns (address) {
        return Approval[_tokenId];
    }

    // getter functions
    function getTokenName() public view returns (string memory) {
        return tokenName;
    }

    function getTokenSymbol() public view returns (string memory) {
        return tokenSymbol;
    }

    function getBalance(address user) public view returns (uint256) {
        // Allow users to check how many tokens they own.
        uint256 balance = 0;
        for (uint256 i = 0; i < totalSupply; i++) {
            if (tokenOwners[i] == user) {
                balance++;
            }
        }
        return balance;
    }

    function getOwner(uint256 _tokenId) public view returns (address) {
        return tokenOwners[_tokenId];
    }
}
