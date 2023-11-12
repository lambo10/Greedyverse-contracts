// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract GreedyVerse {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    address public owner;
    address public teamAddress; // Variable to store team address
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping (address => bool) private _isTaxExempt;

    uint256 public totalSupply;
    string public name;
    string public symbol;
    uint8 public decimals;

    constructor() {
        owner = msg.sender;
        name = "GreedyVerse";
        symbol = "GVERSE";
        decimals = 18;
        _mint(msg.sender, 1e10 * (10 ** 18));
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    // Setter function for team address, only callable by owner
    function setTeamAddress(address newTeamAddress) external onlyOwner {
        require(newTeamAddress != address(0), "Invalid address");
        teamAddress = newTeamAddress;
    }

    function setTaxExempt(address account, bool exempt) external onlyOwner {
        _isTaxExempt[account] = exempt;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function allowance(
        address account,
        address spender
    ) public view returns (uint256) {
        return _allowances[account][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public returns (bool) {
        _transfer(sender, recipient, amount);
        require(
            _allowances[sender][msg.sender] >= amount,
            "ERC20: transfer amount exceeds allowance"
        );
        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
        return true;
    }

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public returns (bool) {
        uint c = _allowances[msg.sender][spender] + addedValue;
        require(c >= addedValue, "SafeMath: addition overflow");
        _approve(msg.sender, spender, c);
        return true;
    }

    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) public returns (bool) {
        require(
            _allowances[msg.sender][spender] >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender] - subtractedValue
        );
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(
            _balances[sender] >= amount,
            "ERC20: transfer amount exceeds balance"
        );

        uint256 tax = 0;
        uint256 amountAfterTax = amount;

        // Apply tax only if neither sender nor recipient is tax exempt
        if (!_isTaxExempt[sender] && !_isTaxExempt[recipient]) {
            tax = amount * 2 / 100; // Calculate 2% tax
            amountAfterTax = amount - tax; // Amount after deducting tax
            require(amountAfterTax + tax == amount, "Tax calculation error"); // Check for overflows
            _balances[teamAddress] += tax; // Add tax to team's balance
            emit Transfer(sender, teamAddress, tax); // Emit event for tax transfer
        }

        _balances[sender] -= amount;
        _balances[recipient] += amountAfterTax;

        emit Transfer(sender, recipient, amountAfterTax);
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");
        uint c = totalSupply + amount;
        require(c >= amount, "SafeMath: addition overflow");
        totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");
        require(
            _balances[account] >= amount,
            "ERC20: burn amount exceeds balance"
        );
        _balances[account] -= amount;
        totalSupply -= amount;
        emit Transfer(account, address(0), amount);
    }

    function _approve(
        address account,
        address spender,
        uint256 amount
    ) internal {
        require(account != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[account][spender] = amount;
        emit Approval(account, spender, amount);
    }

}
