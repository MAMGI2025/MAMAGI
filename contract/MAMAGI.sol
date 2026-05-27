// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MAMAGI {
    string public name = "MAMAGI";
    string public symbol = "MAMGI";
    uint8 public decimals = 18;
    uint256 public totalSupply = 29000000000 * 10 ** 18;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    uint256 public taxRate = 1; // 1%
    address public owner;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        uint256 tax = (amount * taxRate) / 100;
        uint256 amountAfterTax = amount - tax;

        require(balanceOf[msg.sender] >= amount, "Not enough balance");
        require(to != address(0), "Cannot send to zero address");

        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amountAfterTax;
        balanceOf[owner] += tax;

        emit Transfer(msg.sender, to, amountAfterTax);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        uint256 tax = (amount * taxRate) / 100;
        uint256 amountAfterTax = amount - tax;

        require(balanceOf[from] >= amount, "Not enough balance");
        require(allowance[from][msg.sender] >= amount, "Not enough allowance");
        require(to != address(0), "Cannot send to zero address");

        balanceOf[from] -= amount;
        balanceOf[to] += amountAfterTax;
        balanceOf[owner] += tax;
        allowance[from][msg.sender] -= amount;

        emit Transfer(from, to, amountAfterTax);
        return true;
    }

    function renounceOwnership() public {
        require(msg.sender == owner, "Only owner");
        owner = address(0);
    }
}
