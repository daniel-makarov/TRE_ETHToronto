// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/**
 * @title RealEstateToken
 * @dev Tokenizing real estate properties.
 */

contract RealEstateToken {

    string public name;
    string public symbol;
    uint8 public decimals;

    uint256 private _totalSupply;

    // A structure to hold real estate property details
    struct Property {
        string description; // Description of the property
        uint256 value;      // Value of the property in tokens
        bool isAvailable;   // Is property available for purchase
    }

    Property[] public properties; // List of properties

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event PropertyAdded(uint256 propertyId, string description, uint256 value);

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _initialSupply) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;

        _totalSupply += _initialSupply * 10**decimals;
        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    // Function to add a property
    function addProperty(string memory _description, uint256 _value) public returns (uint256) {
        properties.push(Property(_description, _value, true));
        uint256 propertyId = properties.length - 1;
        emit PropertyAdded(propertyId, _description, _value);
        return propertyId;
    }

    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual returns (uint256) {
        return balances[account];
    }

    function allowance(address owner, address spender) public view virtual returns (uint256) {
        return allowances[owner][spender];
    }

    function transfer(address recipient, uint256 amount) external returns (bool) {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
        require(allowances[sender][msg.sender] >= amount, "Allowance exceeded");
        allowances[sender][msg.sender] -= amount;
        require(balances[sender] >= amount, "Insufficient balance");
        balances[sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    // Function to get property details
    function getProperty(uint256 propertyId) public view returns (string memory description, uint256 value, bool isAvailable) {
        require(propertyId < properties.length, "Property does not exist");
        Property memory property = properties[propertyId];
        return (property.description, property.value, property.isAvailable);
    }
}
