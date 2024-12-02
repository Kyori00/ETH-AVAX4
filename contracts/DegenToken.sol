/*
Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
Transferring tokens: Players should be able to transfer their tokens to others.
Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
Checking token balance: Players should be able to check their token balance at any time.
Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
contract DegenToken is ERC20, Ownable {
    uint256 public constant MAX_SUPPLY = 100000; // Max supply set to 100000

    struct Item{
        string name;
        uint256 price;
    }

    constructor() ERC20("Degen", "DGN") {}

    function mint(address to, uint256 value) public onlyOwner validateMint(value) {
        _mint(to, value);
    }

    modifier validateMint(uint256 value) {
        require(totalSupply() + value <= MAX_SUPPLY, "Exceeds maximum supply");
        _;
    }

    function transfer(address to, uint256 value) public override returns (bool) {
        require(balanceOf(msg.sender) >= value, "You do not have enough Degen Tokens");
        approve(msg.sender, value);
        _transfer(msg.sender, to, value);
        return true;
    }

    function burn(uint256 value) external {
        require(balanceOf(msg.sender) >= value, "You do not have enough Degen Tokens");
        _burn(msg.sender, value);
    }

    function checkMyBal() external view returns (uint256){
        return this.balanceOf(msg.sender);
    }

    function showStoreItems() external pure returns (string memory){
        return "Available items:\n"
                "0. DEGEN PLUSHIE - 100 DGN\n"
                "1. DEGEN PURSE - 150 DGN\n"
                "2. DEGEN PANTS - 200 DGN\n";
    }

    function reedeemShop(uint8 userChoice) external {
        uint120 itemPrice;
        if(userChoice == 0){
            itemPrice = 100;
        } else if (userChoice == 1){
            itemPrice = 150;
        } else if (userChoice == 2){
            itemPrice = 200;
        } else {
            revert("Invalid item choice");
        }
        require (balanceOf(msg.sender)>= itemPrice, "You do not have enough Degen Token to redeem this item");
        _burn(msg.sender, itemPrice);
    }

    }

