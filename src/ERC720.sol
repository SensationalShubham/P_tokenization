// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ERC720 {
    string public tokenName;
    string public tokenSymbol;
    uint256 private immutable i_decimal = 10 ** 8; // divisable upto 18th of fraction
    uint256 public totalSupply;
    uint256 public tokenId = 0;
    uint256 public balanceOf;
    // address transfer;
    address transferFrom;
    // bool allowance;
    address immutable i_owner;
    address[] owners;

    constructor(string memory _tName, string memory _tSymbol, uint256 _totalSupply) {
        tokenName = _tName;
        tokenSymbol = _tSymbol;
        totalSupply = _totalSupply;
        i_owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, "Not the actual owner");
        _;
    }

    mapping(address => uint256) tokenIdReference;
    mapping(uint256 => address) public approved; // Stores the approved address for each token ID.

    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    function mint(address to, uint256 _tokenId) public {
        // error - same tokenID kisi aur address ko bhi de sakte h
        tokenIdReference[to] = _tokenId;
    }

    function approve(address to, uint256 _tokenId) public {
        require(tokenIdReference[msg.sender] == _tokenId, "Only token owner can approve this");
        approved[_tokenId] = to; // Assign the approved address for the token ID.
        emit Approval(msg.sender, to, _tokenId);
    }

    function getApproved(uint256 _tokenId) public view returns (address) {
        return approved[_tokenId]; // Return the approved address for the token ID
    }

    function safeTransferFrom(address from, address to, uint256 _tokenId) public returns (bool) {
        // bool - if the transfer is done or not
        require(msg.sender == from, "Wrong person"); // security check
        require(_tokenId <= totalSupply, "Out of limit");
        require(getApproved(_tokenId) == to, "You're not approved yet "); // Checking the approval
        tokenIdReference[to] = _tokenId; // transferring
        delete tokenIdReference[from]; // deleting from previous owner
        return true;
    }

    // Getter Functions

    function getTokenName() public view onlyOwner returns (string memory) {
        return tokenName;
    }

    function getTokenSymbol() public view onlyOwner returns (string memory) {
        return tokenSymbol;
    }

    function getTokenSupply() public view onlyOwner returns (uint256) {
        return totalSupply;
    }

    function getBalanceOf(address user) public view returns (uint256) {
        // Returns the number of tokens owned by a specific address.
        uint256 balance = 0;
        for (uint256 i = 0; i < totalSupply; i++) {
            if (tokenIdReference[user] == i) {
                balance++;
            }
        }
        return balance;
    }

    // function getOwnerOf(uint256 _tokenId) public view returns(address){
    //     // Returns the address of the owner for a specific token ID.
    //     for(address tokenOwner in tokenIdReference){
    //         if(tokenIdReference[tokenOwner] == _tokenId){
    //             return owner;   //  Return the owner's address if a match is found
    //         }
    //     }

    //     return address(0);  // Return 0x0 if no owner is found for the token ID
    // }
}
